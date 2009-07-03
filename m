Return-Path: <linux-kernel-owner+w=401wt.eu-S1759237AbZGCUiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237AbZGCUiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 16:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757036AbZGCUiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 16:38:11 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:42724 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756899AbZGCUiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 16:38:11 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Bug Fix]: Do 32-bit table calculations in pre-processor
Date: Fri, 3 Jul 2009 15:38:07 -0500
User-Agent: KMail/1.9.9
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <ak@linux.intel.com>
References: <200907031314.36243.lkml@morethan.org> <200907031441.04604.lkml@morethan.org> <4A4E609C.5030608@zytor.com>
In-Reply-To: <4A4E609C.5030608@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907031538.11603.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri July 3 2009, H. Peter Anvin wrote:
> Michael S. Zick wrote:
> > 
> > Good point: (1<<(32-PAGE_SIFT)) would handle other than 4k pages.
> > 
> > I just hardcoded it as a working example of the change from setting
> > the page table size by design rather than numeric error.
> > 
> 
> As Jeremy pointed out, it's not wrong as written.  gas by design uses
> arbitrary-precision arithmetic, and even if it didn't, it would still be
> correct: (1 << 32) would collapse to 0, so all the rest of the
> calculations would still be right.
> 
> Any way you can dump out this value from the vmlinux file (nm vmlinux |
> grep MAPPING_BEYOND_END) in both cases?  
>

Can't find it in either case, or with objdump.

(g)as reports itself as version 2.18


> What version of as/binutils do 
> you have installed?
> 
> > And yes, it has 512Mbyte of ram, so 1/2Mbyte page table sounds right to me.
> 
> /proc/cpuinfo, please?
> 

That takes a running machine - which is a bit of a challenge at the moment.
Well, for the past four months, if truth be told.

Anything in particular you are looking for?
I may have it in my notes and data captures.

Mike
> 	-hpa
> 


