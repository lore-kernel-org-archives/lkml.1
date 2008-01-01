Return-Path: <linux-kernel-owner+w=401wt.eu-S1755088AbYAAPS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbYAAPS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbYAAPSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:18:07 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:54184 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754612AbYAAPSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:18:06 -0500
Date: Tue, 1 Jan 2008 17:17:51 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove CONFIG_EXPERIMENTAL
Message-ID: <20080101151751.GW2360@does.not.exist>
References: <20080101134809.GK2360@does.not.exist> <20080101142344.769f16c7@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080101142344.769f16c7@the-village.bc.nu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 02:23:44PM +0000, Alan Cox wrote:
> On Tue, 1 Jan 2008 15:48:09 +0200
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > This patch removes the EXPERIMENTAL option and all dependencies on
> > EXPERIMENTAL since they are pointless.
> 
> NAK
> 
> Experimental is an important guide to driver and code quality. 
>...

History has shown that EXPERIMENTAL tags in many areas of the kernel 
have not been maintained in a way that they would be usable as a guide.

And as soon as you need _one_ driver or feature depending on 
EXPERIMENTAL, you anyway lose all benefits it might have had.

The latter is the point where it makes sense if a user or distribution 
e.g. enables CONFIG_ATA_EXPERIMENTAL for getting all hardware supported 
but not CONFIG_CRYPTO_EXPERIMENTAL because he doesn't want to use
(resp. support usage of) experimental cryptographic algorithm 
implementations.

> >	This patch has been sent on:
> >	 11 Dec 2007
> >	 25 Nov 2007
> >	 17 Nov 2007
> 
> So why not drop it instead. It clearly has no consensus

That's not about consensus, it's more that the number of submissions 
required until Andrew includes a patch into -mm seems to be related to 
the number of files touched...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

