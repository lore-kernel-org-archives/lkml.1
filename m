Return-Path: <linux-kernel-owner+w=401wt.eu-S932890AbYAaRjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890AbYAaRjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 12:39:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756800AbYAaRjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 12:39:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50456 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756357AbYAaRjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 12:39:43 -0500
Date: Thu, 31 Jan 2008 18:39:41 +0100
From: Andi Kleen <ak@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [9/9] GBPAGES: Do kernel direct mapping at boot using
	GB pages
Message-ID: <20080131173941.GH25989@bingen.suse.de>
References: <20080129606.610336873@suse.de> <20080129050637.BD7441B416E@basil.firstfloor.org> <alpine.LFD.1.00.0801311713010.9204@apollo.tec.linutronix.de> <20080131163812.GE25989@bingen.suse.de> <alpine.LFD.1.00.0801311802150.9204@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801311802150.9204@apollo.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 06:10:02PM +0100, Thomas Gleixner wrote:
> On Thu, 31 Jan 2008, Andi Kleen wrote:
> 
> > On Thu, Jan 31, 2008 at 05:17:41PM +0100, Thomas Gleixner wrote:
> > > On Tue, 29 Jan 2008, Andi Kleen wrote:
> > > >
> > > > +static unsigned long direct_entry(unsigned long paddr)
> > > 
> > > Please use a more sensible function name. This one has no association
> > > with the functionality at all.
> > 
> > Can you suggest one? I honestly cannot think of a better one.
> > Its's a "entry" in the "direct" mapping.
> 
> Doh, yes :) It just did not trigger.

I got rid of it now by switching over to the standard pte primitives
(with the usual casts). It's not prettier, but at least more consistent.

I hope i didn't break the paravirt case though, we'll see.

-Andi

