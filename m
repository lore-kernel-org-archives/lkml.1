Return-Path: <linux-kernel-owner+w=401wt.eu-S1752438AbXA1P3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbXA1P3F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 10:29:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbXA1P3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 10:29:05 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54155 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbXA1P3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 10:29:03 -0500
Date: Sun, 28 Jan 2007 15:28:58 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] mm: remove global locks from mm/highmem.c
Message-ID: <20070128152858.GA23410@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Andrew Morton <akpm@osdl.org>
References: <1169993494.10987.23.camel@lappy> <20070128144933.GD16552@infradead.org> <20070128151700.GA7644@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070128151700.GA7644@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 28, 2007 at 04:17:00PM +0100, Ingo Molnar wrote:
> scalability. I did lock profiling on the -rt kernel, which exposes such 
> things nicely. Half of the lock contention events during kernel compile 
> were due to kmap(). (The system had 2 GB of RAM, so 40% lowmem, 60% 
> highmem.)

Numbers please, and not on -rt but on mainline.  Please show the profiles.

> ps. please fix your mailer to not emit Mail-Followup-To headers. In Mutt
>     you can do this via "set followup_to=no" in your .muttrc.

I have told you last time that this is absolutely intentional and I won't
change it.
