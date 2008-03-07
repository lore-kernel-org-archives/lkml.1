Return-Path: <linux-kernel-owner+w=401wt.eu-S1762826AbYCGTBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762826AbYCGTBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 14:01:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759535AbYCGTBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 14:01:39 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45843 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759133AbYCGTBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 14:01:38 -0500
Date: Fri, 7 Mar 2008 20:03:13 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] [8/13] Enable the mask allocator for x86
Message-ID: <20080307190313.GN7365@one.firstfloor.org>
References: <200803071007.493903088@firstfloor.org> <20080307090718.A609E1B419C@basil.firstfloor.org> <20080307183255.GB14779@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080307183255.GB14779@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2008 at 07:32:55PM +0100, Sam Ravnborg wrote:
> On Fri, Mar 07, 2008 at 10:07:18AM +0100, Andi Kleen wrote:
> > 
> > - Disable old ZONE_DMA
> > No fixed size ZONE_DMA now anymore. All existing users of __GFP_DMA rely 
> > on the compat call to the maskable allocator in alloc/free_pages
> > - Call maskable allocator initialization functions at boot
> > - Add TRAD_DMA_MASK for the compat functions 
> 
> I see TRAD_DMA_MASK used by patch 6 and patch 7, but only here
> in this later patch it is defined.
> Looks like we have build breakage - but I have not checked it.

It is only used when the architecture defines CONFIG_MASK_ALLOC and
that is not done by any until the later patches.

-Andi
