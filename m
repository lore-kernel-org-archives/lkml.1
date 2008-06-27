Return-Path: <linux-kernel-owner+w=401wt.eu-S1762059AbYF0RrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762059AbYF0RrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 13:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757649AbYF0Rq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 13:46:57 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:45226 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757156AbYF0Rq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 13:46:56 -0400
Date: Fri, 27 Jun 2008 20:44:41 +0300
From: Adrian Bunk <bunk@kernel.org>
To: David Brownell <david-b@pacbell.net>
Cc: Dan Williams <dan.j.williams@intel.com>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, kernel@avr32linux.org,
       "Nelson, Shannon" <shannon.nelson@intel.com>
Subject: Re: [PATCH v4 4/6] dmaengine: Make DMA Engine menu visible for
	AVR32 users
Message-ID: <20080627174441.GB4306@cs181140183.pp.htv.fi>
References: <1214486603-23655-1-git-send-email-haavard.skinnemoen@atmel.com> <20080626164601.712bf048@hskinnemo-gx745.norway.atmel.com> <1214528379.32709.51.camel@dwillia2-linux.ch.intel.com> <200806270937.21850.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200806270937.21850.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 09:37:21AM -0700, David Brownell wrote:
> On Thursday 26 June 2008, Dan Williams wrote:
> > I agree with removing the arch dependency, and I do not think we
> > necessarily need to add HAVE_DMA_ENGINE.
> 
> I think a HAVE_DMA_ENGINE would be better than what you're doing
> below:  moving the arch dependency into the network code, and
> adding this !HIGHMEM64G thing (which is really just a more subtle
> arch dependency).
>...

The only effect of the HAVE_DMA_ENGINE would be to not show an empty 
kconfig menu.

That's IMHO too much effort for a purely cosmetical kconfig issue.

And I speak as the one who originally added the arch dependency...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

