Return-Path: <linux-kernel-owner+w=401wt.eu-S1763818AbYCGTJD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763818AbYCGTJD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 14:09:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755605AbYCGTIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 14:08:54 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:46234 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481AbYCGTIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 14:08:53 -0500
Date: Fri, 7 Mar 2008 20:09:09 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] [8/13] Enable the mask allocator for x86
Message-ID: <20080307190909.GA15512@uranus.ravnborg.org>
References: <200803071007.493903088@firstfloor.org> <20080307090718.A609E1B419C@basil.firstfloor.org> <20080307183255.GB14779@uranus.ravnborg.org> <20080307190313.GN7365@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080307190313.GN7365@one.firstfloor.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2008 at 08:03:13PM +0100, Andi Kleen wrote:
> On Fri, Mar 07, 2008 at 07:32:55PM +0100, Sam Ravnborg wrote:
> > On Fri, Mar 07, 2008 at 10:07:18AM +0100, Andi Kleen wrote:
> > > 
> > > - Disable old ZONE_DMA
> > > No fixed size ZONE_DMA now anymore. All existing users of __GFP_DMA rely 
> > > on the compat call to the maskable allocator in alloc/free_pages
> > > - Call maskable allocator initialization functions at boot
> > > - Add TRAD_DMA_MASK for the compat functions 
> > 
> > I see TRAD_DMA_MASK used by patch 6 and patch 7, but only here
> > in this later patch it is defined.
> > Looks like we have build breakage - but I have not checked it.
> 
> It is only used when the architecture defines CONFIG_MASK_ALLOC and
> that is not done by any until the later patches.
Understood - I just took a quick look and wanted to let you know.

	Sam
