Return-Path: <linux-kernel-owner+w=401wt.eu-S933999AbXGUV3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933999AbXGUV3l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 17:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933726AbXGUV3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 17:29:12 -0400
Received: from waste.org ([66.93.16.53]:49459 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933685AbXGUV3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 17:29:10 -0400
Date: Sat, 21 Jul 2007 16:28:52 -0500
From: Matt Mackall <mpm@selenic.com>
To: Paul Mundt <lethal@linux-sh.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] mm: Remove slab destructors from kmem_cache_create().
Message-ID: <20070721212851.GH11166@waste.org>
References: <20070720012846.GA22487@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070720012846.GA22487@linux-sh.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 10:28:46AM +0900, Paul Mundt wrote:
> Slab destructors were no longer supported after Christoph's
> c59def9f222d44bb7e2f0a559f2906191a0862d7 change. They've been
> BUGs for both slab and slub, and slob never supported them
> either.

SLOB of course did support destructors, otherwise it wouldn't have
worked.

But good riddance to destructors nonetheless.

-- 
Mathematics is the supreme nostalgia of our time.
