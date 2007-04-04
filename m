Return-Path: <linux-kernel-owner+w=401wt.eu-S2992635AbXDDFV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992635AbXDDFV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 01:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992640AbXDDFV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 01:21:29 -0400
Received: from waste.org ([66.93.16.53]:34644 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992635AbXDDFV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 01:21:28 -0400
Date: Wed, 4 Apr 2007 00:08:58 -0500
From: Matt Mackall <mpm@selenic.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/13] maps: Move the page walker code to lib/
Message-ID: <20070404050857.GU4892@waste.org>
References: <7.486631555@selenic.com> <461320C9.5030601@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461320C9.5030601@yahoo.com.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 01:51:37PM +1000, Nick Piggin wrote:
> Matt Mackall wrote:
> >Move the page walker code to lib/
> >
> >This lets it get shared outside of proc/ and linked in only when
> >needed.
> 
> I think it would be better in mm/.

I originally was looking at putting it in mm/memory.c and possibly
converting some users there. But I decided it ought to be
conditionally linked until it had some core users and I wasn't quite
ready to tackle the tricky mm/ bits.

> So would clear_refs_pte_range, and clear_refs_write (in a more
> generic form), IMO.
> 
> Sweet patchset, though.

Thanks.

-- 
Mathematics is the supreme nostalgia of our time.
