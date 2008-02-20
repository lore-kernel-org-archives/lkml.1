Return-Path: <linux-kernel-owner+w=401wt.eu-S1764016AbYBTASx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764016AbYBTASx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 19:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756057AbYBTASo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 19:18:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:39074 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286AbYBTASn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 19:18:43 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: tsc breaks atkbd suspend
Date: Tue, 19 Feb 2008 19:17:36 -0500
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <len.brown@intel.com>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>, jbohac@suse.cz,
       kernel list <linux-kernel@vger.kernel.org>, jikos@suse.cz,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Andrew Morton <akpm@osdl.org>
References: <20080218133852.GA1573@elf.ucw.cz> <20080219140552.GC9965@elte.hu> <alpine.LFD.1.00.0802191748110.7583@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0802191748110.7583@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802191917.36641.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2008 11:51, Thomas Gleixner wrote:
> On Tue, 19 Feb 2008, Ingo Molnar wrote:
> > * Pavel Machek <pavel@ucw.cz> wrote:
> > 
> > > TSC is used even on machines when CONFIG_X86_TSC is not set (X86_TSC 
> > > means _require_ TSC), but it is not properly disabled when it is 
> > > unusable, because acpi code understood the config switch as "may use 
> > > TSC".
> > > 
> > > This actually fixes suspend problems on my x60.
> > 
> > ah! This makes tons of sense. I've applied your patch

please do not.

> > - but i guess it  should go via the ACPI tree.

yes.

> Right. The breakage was introduced there when IA64 switched to
> GENERIC_TIME and the X86_TSC dependency was added.

so do we need a patch for 2.6.23.stable and 2.6.24.stable?

thanks,
-Len
