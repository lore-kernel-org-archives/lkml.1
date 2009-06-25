Return-Path: <linux-kernel-owner+w=401wt.eu-S1755820AbZFYNO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbZFYNO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 09:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbZFYNOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 09:14:18 -0400
Received: from mail123.emailantidote.com ([80.169.59.123]:64057 "EHLO
	SC-MTA-04.mxsweep.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752175AbZFYNOR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 09:14:17 -0400
X-Greylist: delayed 614 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Jun 2009 09:14:17 EDT
Message-ID: <4A43759B.1000103@draigBrady.com>
Date: Thu, 25 Jun 2009 14:03:23 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: kerneloops.org report for the week of June 14 2009
References: <20090614173331.18f01123@infradead.org> <alpine.LFD.2.00.0906231201430.2767@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0906231201430.2767@localhost.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 25 Jun 2009 13:04:01.0596 (UTC) FILETIME=[68EB67C0:01C9F595]
x-MXSweep-CtasdSpam: Unknown
x-MXSweep-CtasdVirus: Unknown
x-Ctasd-RefID: str=0001.0A010201.4A4375C3.0283,ss=1,fgs=0
x-MXSweep-KeywordsCount: 0
x-MXSweep-MetaScanResult: Clean
x-MXSweep-MetaScanThreat: 
x-MXSweep-VirusScanned: 25/06/2009 13:04:04
x-MXPurifier-SpamScore: 0
x-MXPurifier-VirusScore: 0
x-MXSweep-Threat: Clean
X-MXUniqueID: 9d8b0558-f35f-464b-a424-67397a293312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Sun, 14 Jun 2009, Arjan van de Ven wrote:
>> Rank 3: getnstimeofday (warning)
>> 	Reported 309 times (2446 total reports)
>> 	[suspend resume] getnstimeofday() is called before timekeeping is
>         resumed
> 
>> Rank 6: hres_timers_resume (warning)
>> 	Reported 188 times (1024 total reports)
>> 	[suspend resume] hres_timers_resume() is incorrectly called with
>>       interrupts on
> 
> Both have the same root cause. Something enables interrupts in the
> early resume path. IIRC, there was a culprit identified
> recently. Rafael ?

Lots of reports I guess from Fedora 11 users trying to suspend/resume:
https://bugzilla.redhat.com/show_bug.cgi?id=499651

cheers,
Pádraig.
