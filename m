Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbZLCRFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbZLCRFL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 12:05:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbZLCRFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 12:05:11 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56935 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977AbZLCRFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 12:05:10 -0500
Date: Thu, 3 Dec 2009 17:04:52 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Dmitry Artamonow <mad_soft@inbox.ru>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the pcmcia tree with the arm tree
Message-ID: <20091203170452.GD14241@flint.arm.linux.org.uk>
References: <20091201140310.46dbdc59.sfr@canb.auug.org.au> <20091202115649.GA2150@rainbow>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091202115649.GA2150@rainbow>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 02:56:49PM +0300, Dmitry Artamonow wrote:
> On 14:03 Tue 01 Dec     , Stephen Rothwell wrote:
> > Hi Dominik,
> > 
> > Today's linux-next merge of the pcmcia tree got a conflict in
> > drivers/pcmcia/sa1100_h3600.c between commit
> > 6ce8f65e71f0d80ee23b543be09789dd865a99be ("ARM: 5811/1: pcmcia: convert
> > sa1100_h3600 driver to gpiolib") from the arm tree and commit
> > 66024db57d5b9011e274b314affad68f370c0d6f ("PCMCIA: stop duplicating
> > pci_irq in soc_pcmcia_socket") from the pcmcia tree.
> > 
> > I fixed it up (see below) and can carry the fix as necessary.  Please
> > check the fix below.
> 
> Fix looks good to me, and testing next-20091201 on real device (h3600)
> shows no problems with pcmcia.
> 
> Perhaps this merge conflict can be avoided by merging Russell's PCMCIA
> patches through arm tree. But, anyway, it's Russell and Dominik
> to decide.

If that's what Dominik would like me to do.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
