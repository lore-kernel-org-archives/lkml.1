Return-Path: <linux-kernel-owner+w=401wt.eu-S1762333AbZDQSD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762333AbZDQSD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 14:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761513AbZDQSDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 14:03:20 -0400
Received: from smtp6.welho.com ([213.243.153.40]:33773 "EHLO smtp6.welho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760297AbZDQSDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 14:03:19 -0400
Date: Fri, 17 Apr 2009 21:03:16 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] AHCI updates: Marvell AHCI PATA works;
	pata_marvell fate?
Message-ID: <20090417180316.GA7134@sci.fi>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <20090417023949.GA14469@havoc.gtf.org> <20090417105031.607a771e@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090417105031.607a771e@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 10:50:31AM +0100, Alan Cox wrote:
> > Marvell PATA on 6121 and similar chips should also work, but that hasn't
> > yet been tested.  Here's the full list of what still needs testing:
> > 
> > - master + slave devices
> > - ATAPI
> > - 6121 (6123? others?)
> 
> LBA48
> 
> 
> > 
> > Also, there is the open question of how to deal with pata_marvell
> > co-existence
> 
> I think for the moment make PATA support by AHCI a config option and as
> soon as we trust it we can get rid of the option and of pata_marvell.

How does this relate to 6101 which is a PATA only controller? Would that
continue to use pata_marvell or does this new stuff support such things
too?

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
