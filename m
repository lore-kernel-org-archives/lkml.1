Return-Path: <linux-kernel-owner+w=401wt.eu-S933168AbXCMUQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168AbXCMUQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 16:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933177AbXCMUQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 16:16:22 -0400
Received: from waste.org ([66.93.16.53]:45690 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933168AbXCMUQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 16:16:21 -0400
Date: Tue, 13 Mar 2007 15:03:14 -0500
From: Matt Mackall <mpm@selenic.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, clameter@sgi.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 0/4] Arch independent quicklists V2
Message-ID: <20070313200313.GG10459@waste.org>
References: <20070313071325.4920.82870.sendpatchset@schroedinger.engr.sgi.com> <20070313005334.853559ca.akpm@linux-foundation.org> <45F65ADA.9010501@yahoo.com.au> <20070313035250.f908a50e.akpm@linux-foundation.org> <45F685C6.8070806@yahoo.com.au> <20070313041551.565891b5.akpm@linux-foundation.org> <45F68B4B.9020200@yahoo.com.au> <20070313044756.b45649ac.akpm@linux-foundation.org> <45F69287.8040509@yahoo.com.au> <45F6DFA2.9060106@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F6DFA2.9060106@goop.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 10:30:10AM -0700, Jeremy Fitzhardinge wrote:
> Nick Piggin wrote:
> > However we still have to visit those to-be-unmapped parts of the page
> > table,
> > to find the pages and free them. So we still at least need to bring it
> > into
> > cache for the read... at which point, the store probably isn't a big
> > burden.
> 
> Why not try to find a place to stash a linklist pointer and link them
> all together?  Saves the pulldown pagetable walk altogether.

Because we'd need one link per mm that a page is mapped in?

-- 
Mathematics is the supreme nostalgia of our time.
