Return-Path: <linux-kernel-owner+w=401wt.eu-S1762002AbYCGLN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762002AbYCGLN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 06:13:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757359AbYCGLNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 06:13:20 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46102 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757104AbYCGLNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 06:13:19 -0500
Date: Fri, 7 Mar 2008 12:14:52 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] [6/13] Core maskable allocator
Message-ID: <20080307111452.GA7365@one.firstfloor.org>
References: <200803071007.493903088@firstfloor.org> <20080307090716.9D3E91B419C@basil.firstfloor.org> <871w6m955h.fsf@saeurebad.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871w6m955h.fsf@saeurebad.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +		}
> > +#endif
> > +		p = alloc_pages(gfp_mask|__GFP_NOWARN, order);
> 
> ... isn't this a leak here?

You're right -- this needs a check. Weird wonder why the tests didn't
catch that.

Thanks,
-Andi
