Return-Path: <linux-kernel-owner+w=401wt.eu-S1751592AbZG3Ql4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbZG3Ql4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 12:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbZG3Qlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 12:41:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:58622 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbZG3Qly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 12:41:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: eranian@gmail.com
Subject: Re: I.1 - System calls - ioctl
Date: Thu, 30 Jul 2009 18:40:50 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-3-generic; KDE/4.2.96; x86_64; ; )
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       "perfmon2-devel" <perfmon2-devel@lists.sourceforge.net>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com> <1248963211.6391.45.camel@twins> <7c86c4470907300917s5d3f2bf0iefe333cefc08c7fa@mail.gmail.com>
In-Reply-To: <7c86c4470907300917s5d3f2bf0iefe333cefc08c7fa@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200907301840.50894.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/kveurx76K3AQa327zCEQlmqqs3BJcSXQl82s
 tRfiAKYp9Hm75YvGxbFfMfB14Snq/f7j8Mr1xiVH7ZjtQ6f+Wx
 dfhpl+7d4Ag3OZpWkmrsA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 July 2009, stephane eranian wrote:
> long sys_perf_counter_open(
>        struct perf_counter_attr *attr,
>        enum perf_target_type  target_type,
>        int target_id,
>        int group_fd,
>        unsigned long flags);
> 
> Which is what you had, except without the struct.
> 
> Then, it boils down to whether expressing a target id in 32 bits is enough.
> Obviously, 64-bit would be the safest but then I understand this causes issues
> on 32-bit systems.

Just make it an unsigned long then, that still covers all cases
where you only need the 64-bit type on 64-bit systems.

	Arnd <><
