Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbZI3CSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbZI3CSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 22:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbZI3CSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 22:18:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:28323 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504AbZI3CSL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 22:18:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,476,1249282800"; 
   d="scan'208";a="452928637"
From: "Wang, Shane" <shane.wang@intel.com>
To: Arjan van de Ven <arjan@infradead.org>, Pavel Machek <pavel@ucw.cz>
CC: "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Cihula, Joseph" <joseph.cihula@intel.com>
Date: Wed, 30 Sep 2009 10:16:55 +0800
Subject: RE: [GIT PULL] x86/txt for v2.6.32
Thread-Topic: [GIT PULL] x86/txt for v2.6.32
Thread-Index: AcpBKSUU+7a0QAxGSMyt52SUZQa3MwASh2Gg
Message-ID: <037F493892196B458CD3E193E8EBAD4F01ED9FE3B1@pdsmsx502.ccr.corp.intel.com>
References: <200909142051.n8EKpiOM017912@terminus.zytor.com>
	<200909262344.21257.rjw@sisk.pl>	<20090928210252.GD1960@elf.ucw.cz>
	<200909282307.56190.rjw@sisk.pl>	<4AC1267D.6020405@zytor.com>
	<20090928211745.GA2119@elf.ucw.cz>	<4AC1AA61.8070408@intel.com>
	<20090929171318.GC14405@elf.ucw.cz> <20090929191951.18315e94@infradead.org>
In-Reply-To: <20090929191951.18315e94@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Tue, 29 Sep 2009 19:13:18 +0200
> Pavel Machek <pavel@ucw.cz> wrote:
> 
>> Ok, and what prevents me from commenting out the MAC checking code?
>> 
> 
> because the bios verified some code that verified the kernel which
> includes the MAC checking code .. as part of returning from S3 ?

Yes, S3 sleep/resume cause another cycle to build the measured environment.
i.e. SINIT will verify tboot, tboot will verify kernel mem, kernel will verify userspace mem.
If you comment out the MAC checking code in any party, the chain will lost and S3 resume will fail.

Thanks.
Shane

