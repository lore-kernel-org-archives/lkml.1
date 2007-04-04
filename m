Return-Path: <linux-kernel-owner+w=401wt.eu-S2992895AbXDDNGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992895AbXDDNGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 09:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992896AbXDDNGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 09:06:16 -0400
Received: from ns1.suse.de ([195.135.220.2]:48064 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992895AbXDDNGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 09:06:15 -0400
Date: Wed, 4 Apr 2007 15:05:59 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <npiggin@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>, tee@sgi.com,
       holt@sgi.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] no ZERO_PAGE?
Message-ID: <20070404130559.GD19587@v2.random>
References: <20070329075805.GA6852@wotan.suse.de> <Pine.LNX.4.64.0703291324090.21577@blonde.wat.veritas.com> <20070330024048.GG19407@wotan.suse.de> <20070404033726.GE18507@wotan.suse.de> <Pine.LNX.4.64.0704041023040.17341@blonde.wat.veritas.com> <20070404102407.GA529@wotan.suse.de> <Pine.LNX.4.64.0704041338450.7416@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704041338450.7416@blonde.wat.veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 01:45:06PM +0100, Hugh Dickins wrote:
> I'm confused.  CONFIG_ZERO_PAGE off is where we'd like to end up: how
> would turning CONFIG_ZERO_PAGE on in -rc kernels help us to get there?

He most certainly meant on by default.

I think if we do this, we also need a zeropage counter in the vm stats
so that we'll get a measure of the waste and it'll be possible to
identify apps to optimize/fix.
