Return-Path: <linux-kernel-owner+w=401wt.eu-S1759766AbYBTGwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759766AbYBTGwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 01:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbYBTGw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 01:52:26 -0500
Received: from www.tglx.de ([62.245.132.106]:55350 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbYBTGwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 01:52:25 -0500
Date: Wed, 20 Feb 2008 07:51:43 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Len Brown <lenb@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <len.brown@intel.com>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>, jbohac@suse.cz,
       kernel list <linux-kernel@vger.kernel.org>, jikos@suse.cz,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Andrew Morton <akpm@osdl.org>
Subject: Re: tsc breaks atkbd suspend
In-Reply-To: <200802191917.36641.lenb@kernel.org>
Message-ID: <alpine.LFD.1.00.0802200751010.7583@apollo.tec.linutronix.de>
References: <20080218133852.GA1573@elf.ucw.cz> <20080219140552.GC9965@elte.hu> <alpine.LFD.1.00.0802191748110.7583@apollo.tec.linutronix.de> <200802191917.36641.lenb@kernel.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008, Len Brown wrote:

> On Tuesday 19 February 2008 11:51, Thomas Gleixner wrote:
> > On Tue, 19 Feb 2008, Ingo Molnar wrote:
> > > * Pavel Machek <pavel@ucw.cz> wrote:
> > > 
> > > > TSC is used even on machines when CONFIG_X86_TSC is not set (X86_TSC 
> > > > means _require_ TSC), but it is not properly disabled when it is 
> > > > unusable, because acpi code understood the config switch as "may use 
> > > > TSC".
> > > > 
> > > > This actually fixes suspend problems on my x60.
> > > 
> > > ah! This makes tons of sense. I've applied your patch
> 
> please do not.

It's not in the -mm branch.
 
> > > - but i guess it  should go via the ACPI tree.
> 
> yes.
> 
> > Right. The breakage was introduced there when IA64 switched to
> > GENERIC_TIME and the X86_TSC dependency was added.
> 
> so do we need a patch for 2.6.23.stable and 2.6.24.stable?

Yes.

Thanks,
	tglx
