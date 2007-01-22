Return-Path: <linux-kernel-owner+w=401wt.eu-S932416AbXAVUAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416AbXAVUAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 15:00:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932463AbXAVUAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 15:00:14 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:48281 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932416AbXAVUAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 15:00:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=JqQ5cjt0ZCQYKU8lLXip1Ouvib4gDpsLmklCmZbM9vJwtoa+4u2832MPx4n2gkVsTzaSNiIlINcmPpoU1+U4V6KUt6wQJ1BiSvh/fnIcYjOImjfa8i4+Q/HxIOSfJgx/wB5n9cOoP4Fr7Dnlpa/oyf3SC4X7ed9xDAbwO3st3GU=
Date: Mon, 22 Jan 2007 21:00:04 +0100
From: Luca Tettamanti <kronos.it@gmail.com>
To: Jay Cliburn <jacliburn@bellsouth.net>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, jeff@garzik.org,
       shemminger@osdl.org, csnook@redhat.com, hch@infradead.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       atl1-devel@lists.sourceforge.net, kronos.it@gmail.com
Subject: Re: [PATCH 4/4] atl1: Ancillary C files for Attansic L1 driver
Message-ID: <20070122200004.GA12553@dreamland.darkstar.lan>
References: <20070121210737.GE2702@osprey.hogchain.net> <20070121183151.4be61ebf.randy.dunlap@oracle.com> <45B43093.6060500@bellsouth.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45B43093.6060500@bellsouth.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Il Sun, Jan 21, 2007 at 09:33:39PM -0600, Jay Cliburn ha scritto: 
> Randy Dunlap wrote:
> >On Sun, 21 Jan 2007 15:07:37 -0600 Jay Cliburn wrote:
> [snip]
> 
> >>+	value = ioread16(hw->hw_addr + REG_PCIE_CAP_LIST);
> >>+	return ((value & 0xFF00) == 0x6C00) ? 0 : 1;
> >
> >Are there defines or enums for these?
> >Fewer magic numbers would be nice/helpful/readable.
> [snip]
> >>+	s32 ret;
> >>+	ret = atl1_write_phy_reg(hw, 29, 0x0029);
> >
> >Fewer magic numbers?
> 
> Unfortunately, we don't have a spec.  This is how the vendor coded it.
> 
> [snip]
> >>+
> >>+int enable_msi;
> >>+module_param(enable_msi, int, 0444);
> >>+MODULE_PARM_DESC(enable_msi, "Enable PCI MSI");
> >
> >Hm, I thought that we didn't want individual drivers having MSI config
> >options...
> 
> Luca?  This one was yours IIRC.  Care to chime in?

I remember that discussion, but since there's no sistem-wide MSI
blacklist (or whitelist) I don't think it's safe to enable it
unconditionally. Judging from bug reports on lkml it's not safe to
assume that MSI support is sane on non-Intel chipsets.

Luca
-- 
Il coraggio non mi manca.
E` la paura che mi frega...
