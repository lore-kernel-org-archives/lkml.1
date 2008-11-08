Return-Path: <linux-kernel-owner+w=401wt.eu-S1753221AbYKHCLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbYKHCLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 21:11:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbYKHCLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 21:11:37 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33268 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbYKHCLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 21:11:36 -0500
Date: Sat, 8 Nov 2008 00:13:15 -0200
From: Glauber Costa <glommer@redhat.com>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH 0/4] Fix vmalloc regression
Message-ID: <20081108021315.GB21674@poweredge.glommer>
References: <1226097354-7523-1-git-send-email-glommer@redhat.com> <20081108005832.GA2068@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081108005832.GA2068@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 08, 2008 at 01:58:32AM +0100, Nick Piggin wrote:
> On Fri, Nov 07, 2008 at 08:35:50PM -0200, Glauber Costa wrote:
> > Nick,
> > 
> > This is the whole set of patches I was talking about.
> > Patch 3 is the one that in fact fixes the problem
> > Patches 1 and 2 are debugging aids I made use of, and could be possibly
> > useful to others
> > Patch 4 removes guard pages entirely for non-debug kernels, as we have already
> > previously discussed.
> > 
> > Hope it's all fine.
> 
> OK, these all look good, but I may only push 3/4 for Linus in this round,
> along with some of the changes from my patch that you tested as well.

Makes total sense.
> 
> With the DEBUG_PAGEALLOC case, I have been thinking that we perhaps should
> turn off the lazy unmapping optimisation as well, so it catches use
> after free similarly to the page allocator... but probably it is a good
> idea at least to avoid the double-guard page for 2.6.28?

Makes sense. Maybe poisoning after free would also be useful?
