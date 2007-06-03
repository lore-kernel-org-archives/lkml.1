Return-Path: <linux-kernel-owner+w=401wt.eu-S1755007AbXFCQcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbXFCQcP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 12:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbXFCQcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 12:32:01 -0400
Received: from waste.org ([66.93.16.53]:54545 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819AbXFCQcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 12:32:00 -0400
Date: Sun, 3 Jun 2007 11:27:31 -0500
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Bunk <bunk@stusta.de>, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: Conditionals for development tests and output
Message-ID: <20070603162730.GQ11166@waste.org>
References: <Pine.LNX.4.64.0706012113200.11472@schroedinger.engr.sgi.com> <20070602144348.GD5500@stusta.de> <20070602104821.d2d8d668.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070602104821.d2d8d668.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 02, 2007 at 10:48:21AM -0700, Andrew Morton wrote:
> On Sat, 2 Jun 2007 16:43:48 +0200 Adrian Bunk <bunk@stusta.de> wrote:
> 
> > And your approach could easily result in code paths never tested in 
> > -mm or -rc kernels exploding in the actual release.
> 
> yep, we need to ensure that DEVELKERNEL gets turned off a few weeks
> before final release.

I'm not very keen on this whole idea. It's a fairly well-known
phenomenon that behavior can change for the worse when you turn off
debug flags for a variety of reasons. So instituting a monoculture
where -everyone- has a global debug flag on then turns it off is a little
worrisome.

When we're talking about a single warning, it's probably not a big
deal, but once we expand the usage to cover a dozen or a hundred
things, the odds that we'll hide a race or side-effect somewhere
increase.

-- 
Mathematics is the supreme nostalgia of our time.
