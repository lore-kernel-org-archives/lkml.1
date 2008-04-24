Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbYDXKpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbYDXKpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 06:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbYDXKow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 06:44:52 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:53695 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbYDXKov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 06:44:51 -0400
Date: Thu, 24 Apr 2008 13:44:06 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tejun Heo <htejun@gmail.com>, jgarzik@pobox.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove ata_cable_sata()
Message-ID: <20080424104406.GB2559@cs181133002.pp.htv.fi>
References: <20080421085131.GE26897@cs181133002.pp.htv.fi> <20080423192243.1f117215@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080423192243.1f117215@the-village.bc.nu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 07:22:43PM +0100, Alan Cox wrote:
> On Mon, 21 Apr 2008 11:51:31 +0300
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > This patch removes the no longer used ata_cable_sata()
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> NAK - this one is a sensible part of the driver API

I must have missed something.

I thought that you could simply set .flags in a driver without needing 
any helper for .cable_detect .

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

