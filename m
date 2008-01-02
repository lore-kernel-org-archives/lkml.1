Return-Path: <linux-kernel-owner+w=401wt.eu-S1758575AbYABAGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575AbYABAGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 19:06:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755057AbYABAGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 19:06:24 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:52199 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754902AbYABAGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 19:06:23 -0500
Date: Wed, 2 Jan 2008 02:06:08 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove CONFIG_EXPERIMENTAL
Message-ID: <20080102000608.GK27566@does.not.exist>
References: <20080101134809.GK2360@does.not.exist> <20080101142344.769f16c7@the-village.bc.nu> <20080101151751.GW2360@does.not.exist> <20080101160708.5bb5cc2a@the-village.bc.nu> <20080101163337.GX2360@does.not.exist> <20080101173532.1db4019f@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080101173532.1db4019f@the-village.bc.nu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 05:35:32PM +0000, Alan Cox wrote:
> > So smbfs is still considered rock solid while no serious distribution 
> > would be crazy enough to ship the EXPERIMENTAL NFSv4 support to their 
> > customers?
> 
> Thats a different problem. The kernel as I've said many times has no
> proper process for
> 
> - removing expired/missing maintainers
> - handling stuff that decays
> - removing dead documentation
> - removing dead drivers and ports
> 
> Although you've certainly started on fixing much of that.
> 
> > I'm not claiming that all EXPERIMENTAL tags were wrong [1], but many 
> > were wrong.
> 
> So why not fix the wrong tags, and mark smbfs obsolete ?

It's also the other way around:
Is e.g. NFSv4 support really still experimental?

There are only few parts of the kernel where the EXPERIMENTAL tags are 
actually maintained, but most of them were simply added once and stayed 
forever. If my "remove all EXPERIMENTAL tags" approach is not considered 
the best solution I have no problem with starting with "convert 
EXPERIMENTAL to FOO_EXPERIMENTAL in all areas where the subsystem 
maintainer wants to do so" and remove the remaining EXPERIMENTAL tags 
later.

> > Plus the fact that CONFIG_EXPERIMENTAL controlled so many different 
> > things with one switch that CONFIG_EXPERIMENTAL=n .config's are really 
> > rare.
> 
> Agreed

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

