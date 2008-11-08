Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbYKHA6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbYKHA6n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 19:58:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbYKHA6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 19:58:35 -0500
Received: from cantor.suse.de ([195.135.220.2]:56024 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbYKHA6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 19:58:34 -0500
Date: Sat, 8 Nov 2008 01:58:32 +0100
From: Nick Piggin <npiggin@suse.de>
To: Glauber Costa <glommer@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH 0/4] Fix vmalloc regression
Message-ID: <20081108005832.GA2068@wotan.suse.de>
References: <1226097354-7523-1-git-send-email-glommer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226097354-7523-1-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 08:35:50PM -0200, Glauber Costa wrote:
> Nick,
> 
> This is the whole set of patches I was talking about.
> Patch 3 is the one that in fact fixes the problem
> Patches 1 and 2 are debugging aids I made use of, and could be possibly
> useful to others
> Patch 4 removes guard pages entirely for non-debug kernels, as we have already
> previously discussed.
> 
> Hope it's all fine.

OK, these all look good, but I may only push 3/4 for Linus in this round,
along with some of the changes from my patch that you tested as well.

With the DEBUG_PAGEALLOC case, I have been thinking that we perhaps should
turn off the lazy unmapping optimisation as well, so it catches use
after free similarly to the page allocator... but probably it is a good
idea at least to avoid the double-guard page for 2.6.28?

Anyway thanks for these, I'll send them up to Andrew/Linus and cc you.

