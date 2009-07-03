Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbZGCJd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbZGCJd2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 05:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbZGCJdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 05:33:20 -0400
Received: from mga05.intel.com ([192.55.52.89]:27712 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751678AbZGCJdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 05:33:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,340,1243839600"; 
   d="scan'208";a="704761424"
Date: Fri, 3 Jul 2009 11:35:18 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Daniel Ribeiro <drwyrm@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>
Subject: Re: [PATCHv3] PCAP regulator driver (for 2.6.32)
Message-ID: <20090703093517.GA4176@sortiz.org>
References: <1246072682.10360.424.camel@brutus> <20090627105150.GA4780@sirena.org.uk> <1246123618.3727.29.camel@brutus>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1246123618.3727.29.camel@brutus>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Sat, Jun 27, 2009 at 02:26:58PM -0300, Daniel Ribeiro wrote:
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
> Ideally, Samuel would push the PCAP patches on -rc phase, so the
> sub-drivers can all be merged through the respective subsystem trees on
> the .32 merge window.
If that's ok with Liam, I'll take the regulator patch. Most of the pcap
patches are not rc material, so they will be merged along with the regulator
driver with the next merge window.

Liam, if you're fine with this patch, could you please SOB it ? Thanks.

Cheers,
Samuel.


> -- 
> Daniel Ribeiro



-- 
Intel Open Source Technology Centre
http://oss.intel.com/
