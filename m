Return-Path: <linux-kernel-owner+w=401wt.eu-S1759194AbZF2KXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759194AbZF2KXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 06:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758624AbZF2KXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 06:23:34 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:47140 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757788AbZF2KXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 06:23:33 -0400
Subject: Re: [PATCHv3] PCAP regulator driver (for 2.6.32)
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Daniel Ribeiro <drwyrm@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@linux.intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>
In-Reply-To: <1246123618.3727.29.camel@brutus>
References: <1246072682.10360.424.camel@brutus>
	 <20090627105150.GA4780@sirena.org.uk>  <1246123618.3727.29.camel@brutus>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Jun 2009 11:23:34 +0100
Message-Id: <1246271014.30631.37.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-27 at 14:26 -0300, Daniel Ribeiro wrote:
> Em Sáb, 2009-06-27 às 11:51 +0100, Mark Brown escreveu:
> > On Sat, Jun 27, 2009 at 12:18:02AM -0300, Daniel Ribeiro wrote:
> > > Add (partial) support for the voltage regulators on the PCAP2 PMIC.
> > > 
> > > Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>
> > 
> > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > 
> > Looks good.
> 
> Thanks.
> 
> > > Mark, can you please assert that this only gets merged after Samuel has
> > > a chance to merge the set_bits patch? Thanks!
> > 
> > It's Liam who manages the regulator tree, though given the set_bits()
> > patch perhaps this one might end up getting merged via the MFD tree (or
> > both via the regulator tree).
> 
> I prefer the set_bits() patch going through the MFD tree. I sent some
> other fixes, and a patch to solve a similar race issue for the ADC/TS
> driver.
> 

Is this a runtime or build time dependency for this patch ? I'm thinking
about not breaking -next builds.  

> Ideally, Samuel would push the PCAP patches on -rc phase, so the
> sub-drivers can all be merged through the respective subsystem trees on
> the .32 merge window.
> 

I'm sure Samuel will give me a kick when he pushes mfd for .32.

Liam

