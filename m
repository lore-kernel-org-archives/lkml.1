Return-Path: <linux-kernel-owner+w=401wt.eu-S1765960AbYBUXlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765960AbYBUXlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 18:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbYBUXlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 18:41:05 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:50354 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792AbYBUXlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 18:41:04 -0500
Date: Fri, 22 Feb 2008 01:40:18 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Roland Dreier <rdreier@cisco.com>,
       Linus Torvalds <torvalds@osdl.org>,
       Glenn Streiff <gstreiff@NetEffect.com>,
       Faisal Latif <flatif@NetEffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: Merging of completely unreviewed drivers
Message-ID: <20080221234018.GE28328@cs181133002.pp.htv.fi>
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2> <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2> <20080221154951.GA28328@cs181133002.pp.htv.fi> <adahcg2awag.fsf@cisco.com> <20080221210124.GD28328@cs181133002.pp.htv.fi> <20080221140855.6aea8cc1@laptopd505.fenrus.org> <47BDFC26.8000201@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47BDFC26.8000201@garzik.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 05:33:10PM -0500, Jeff Garzik wrote:
>...
> But similarly...  I merge drivers long before our SCSI maintainer will,  
> and I value "it works" above stupid checkpatch warnings.

I was not talking about checkpatch warnings.

I'm talking about checkpatch errors for code like
						if ((page_count!=0)&&(page_count<<12)-(region->offset&(4096-1))>=region->length)

I have to accept that Linus prefers to have the driver merged first and 
let janitors make the code readable in subsequent patches, but if GNU 
indent wasn't unable to properly cope with the fact that this driver has 
over 2000 lines that are over 80 characters long I'd simply run this 
driver through scripts/Lindent .

> 	Jeff

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

