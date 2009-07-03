Return-Path: <linux-kernel-owner+w=401wt.eu-S1759318AbZGCVC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318AbZGCVC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 17:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757910AbZGCVCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 17:02:20 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:52587 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779AbZGCVCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 17:02:19 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Bug Fix]: Do 32-bit table calculations in pre-processor
Date: Fri, 3 Jul 2009 16:02:18 -0500
User-Agent: KMail/1.9.9
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <ak@linux.intel.com>
References: <200907031314.36243.lkml@morethan.org> <200907031538.11603.lkml@morethan.org> <4A4E6CB4.90600@zytor.com>
In-Reply-To: <4A4E6CB4.90600@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907031602.20948.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri July 3 2009, H. Peter Anvin wrote:
> Michael S. Zick wrote:
> > 
> > That takes a running machine - which is a bit of a challenge at the moment.
> > Well, for the past four months, if truth be told.
> > 
> > Anything in particular you are looking for?
> > I may have it in my notes and data captures.
> > 
> 
> The CPUID flags, in particular the pse flag.
> 

I haven't touch anything that would have changed that -
so this should be representative (the *&^*% datasheet says yes to pse also)

processor       : 0
vendor_id       : CentaurHauls
cpu family      : 6
model           : 13
model name      : VIA C7-M Processor 1200MHz
stepping        : 0
cpu MHz         : 600.024
cache size      : 128 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
cmov pat clfl ush acpi mmx fxsr sse sse2 tm nx up pni est tm2 xtpr rng 
rng_en ace ace_en ace2 ace2 _en phe phe_en pmm pmm_en
bogomips        : 1201.11
clflush size    : 64

That's from a 2.6.25 rescue disk - should be close enough.
At least until I get the machine running again.

Mike
> 	-hpa
> 


