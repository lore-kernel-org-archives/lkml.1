Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbYCHLjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbYCHLjx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 06:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbYCHLjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 06:39:45 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58070 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbYCHLjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 06:39:44 -0500
Date: Sat, 8 Mar 2008 12:41:22 +0100
From: Andi Kleen <andi@firstfloor.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] [6/13] Core maskable allocator
Message-ID: <20080308114122.GA27074@one.firstfloor.org>
References: <200803071007.493903088@firstfloor.org> <20080307090716.9D3E91B419C@basil.firstfloor.org> <20080308140334.15987554.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080308140334.15987554.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +early_param("maskzone", setup_maskzone);
> 
> please confirm mask_zone_size is aligned to MAX_ORDER.

It's not. Since the buddy allocator is not used MAX_ORDER doesn't really
exist for the mask allocator. It can handle arbitary size allocations.

Also strictly seen the maskzone is part of the lowmem zone.

-Andi

