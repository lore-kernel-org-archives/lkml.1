Return-Path: <linux-kernel-owner+w=401wt.eu-S1755138AbZALLfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbZALLfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 06:35:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751082AbZALLfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 06:35:37 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:39854 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbZALLfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 06:35:36 -0500
Date: Mon, 12 Jan 2009 14:35:44 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nick Piggin <npiggin@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Richard Henderson <rth@twiddle.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alpha: fix vmalloc breakage
Message-ID: <20090112113544.GA4609@jurassic.park.msu.ru>
References: <20090107230144.GA30170@jurassic.park.msu.ru> <20090111230430.GA17873@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090111230430.GA17873@cmpxchg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 12:04:30AM +0100, Johannes Weiner wrote:
> > +		va = alloc_bootmem(sizeof(struct vmap_area));
> > +		if (!va)
> > +			break;
> 
> You don't need this check, alloc_bootmem() panics when it fails.

Ah, indeed. Thanks.

Ivan.
