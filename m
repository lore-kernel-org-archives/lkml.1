Return-Path: <linux-kernel-owner+w=401wt.eu-S1762984AbYCGScr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762984AbYCGScr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 13:32:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758644AbYCGSck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 13:32:40 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:60297 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758075AbYCGScj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 13:32:39 -0500
Date: Fri, 7 Mar 2008 19:32:55 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] [8/13] Enable the mask allocator for x86
Message-ID: <20080307183255.GB14779@uranus.ravnborg.org>
References: <200803071007.493903088@firstfloor.org> <20080307090718.A609E1B419C@basil.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080307090718.A609E1B419C@basil.firstfloor.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2008 at 10:07:18AM +0100, Andi Kleen wrote:
> 
> - Disable old ZONE_DMA
> No fixed size ZONE_DMA now anymore. All existing users of __GFP_DMA rely 
> on the compat call to the maskable allocator in alloc/free_pages
> - Call maskable allocator initialization functions at boot
> - Add TRAD_DMA_MASK for the compat functions 

I see TRAD_DMA_MASK used by patch 6 and patch 7, but only here
in this later patch it is defined.
Looks like we have build breakage - but I have not checked it.

	Sam
