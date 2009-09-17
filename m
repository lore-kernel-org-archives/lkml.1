Return-Path: <linux-kernel-owner+w=401wt.eu-S1752562AbZIQTdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbZIQTdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 15:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbZIQTdC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 15:33:02 -0400
Received: from mail2.shareable.org ([80.68.89.115]:46851 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbZIQTdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 15:33:01 -0400
Date: Thu, 17 Sep 2009 20:32:57 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Steve Chen <schen@mvista.com>,
       Felipe Contreras <felipe.contreras@gmail.com>,
       linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
       Pavel Machek <pavel@ucw.cz>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: remove unused code in delay.S
Message-ID: <20090917193257.GA10599@shareable.org>
References: <1252875960-21512-1-git-send-email-felipe.contreras@gmail.com> <20090915103739.GA19519@elf.ucw.cz> <1253017761.3273.117.camel@linux-1lbu> <200909151541.08852.marek.vasut@gmail.com> <1253032210.3273.128.camel@linux-1lbu> <94a0d4530909151158y489a96e3x63ff932c713822b0@mail.gmail.com> <1253043875.3273.131.camel@linux-1lbu> <m3k4zzdimy.fsf@intrepid.localdomain> <20090916134721.GA11218@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090916134721.GA11218@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:
> On Tue, Sep 15, 2009 at 11:04:37PM +0200, Krzysztof Halasa wrote:
> > Steve Chen <schen@mvista.com> writes:
> > 
> > > +config OLD_CPU_DELAY
> > > +	depends on CPU_32v3 || CPU_32v4 || CPU_32v4T
> > > +	bool "Accurate delays"
> > > +	def_bool n
> > > +	help
> > > +	  Enable if observing longer than expected delays and need more
> > > +	  accuracy.  This only applies to older CPUs.
> > > +
> > 
> > If it's that simple then why not enable the extra delay code
> > unconditionally when compiling for those CPUs?
> 
> Because it's really not that clear cut.  Eg, ARM610 and ARM710 work
> better with it, but StrongARM suffers from delays being too short.
> Having a kernel configured for all those processors used to be common
> (since the Acorn RiscPC had pluggable CPU cards, which could be one
> of those processors.)
> 
> It's really something that only experienced people should worry
> about, and not Joe "kernel-builder" Bloggs.

I'm confused now.  If I'm building a "generic" kernel to run on
several different systems, including some ARM710s and some StrongARMs,
do I include the code or not?

Btw, do you know where PT110 fits in?  Is it like StrongARM (SA110)?

Thanks,
-- Jamie

