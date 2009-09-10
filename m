Return-Path: <linux-kernel-owner+w=401wt.eu-S1755201AbZIJHFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbZIJHFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 03:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755162AbZIJHFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 03:05:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63301 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbZIJHFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 03:05:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: [RFC][v6][PATCH 7/9]: Define do_fork_with_pids()
Date: Thu, 10 Sep 2009 09:05:35 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-9-generic; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>,
       Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
References: <20090910060627.GA24343@us.ibm.com> <20090910061227.GF25883@us.ibm.com>
In-Reply-To: <20090910061227.GF25883@us.ibm.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909100905.35817.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+S0+f574R7f5RPEuSexdGj6hDGllE7eoWKz78
 toAA9e5AXC99N/kA58AUfPWLzBNsEqtfeLTvha0p3W9QimYTzI
 tqba9+J0ntPiBzIKrDRQg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 September 2009, Sukadev Bhattiprolu wrote:
> +long do_fork(unsigned long clone_flags,
> +             unsigned long stack_start,
> +             struct pt_regs *regs,
> +             unsigned long stack_size,
> +             int __user *parent_tidptr,
> +             int __user *child_tidptr)
> +{
> +       return do_fork_with_pids(clone_flags, stack_start, regs, stack_size,
> +                       parent_tidptr, child_tidptr, NULL);
> +}
> +

How about making this one a static inline in linux/sched.h?

	Arnd <><
