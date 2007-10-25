Return-Path: <linux-kernel-owner+w=401wt.eu-S1755684AbXJYTWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbXJYTWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 15:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbXJYTW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 15:22:26 -0400
Received: from waste.org ([66.93.16.53]:32893 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbXJYTWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 15:22:25 -0400
Date: Thu, 25 Oct 2007 14:21:45 -0500
From: Matt Mackall <mpm@selenic.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Johannes Berg <johannes@sipsolutions.net>, sam@ravnborg.org
Subject: Re: [PATCH 0/6] kernel-doc: add DOC: sections support
Message-ID: <20071025192145.GQ19691@waste.org>
References: <11932637282902@xenotime.net> <20071025172932.GN17536@waste.org> <20071025103611.f2ae216f.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071025103611.f2ae216f.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 10:36:11AM -0700, Randy Dunlap wrote:
> On Thu, 25 Oct 2007 12:29:32 -0500 Matt Mackall wrote:
> 
> > On Wed, Oct 24, 2007 at 03:08:48PM -0700, Randy Dunlap wrote:
> > > 
> > > This patch series from Johannes Berg adds support for DOC: sections
> > > that are embedded in source files.
> > 
> > What do these look like?
> 
> There are currently 2 files in the kernel tree that contain DOC:
> sections.  These are not used in the docbooks, but you can see what
> they look like here:
> 
> ./drivers/net/3c501.c: * DOC: 3c501 Card Notes
> ./drivers/net/3c501.c: * DOC: Problems
> ./drivers/net/3c527.c: * DOC: Traps for the unwary
> ./drivers/net/3c527.c: * DOC: Theory Of Operation
> ./drivers/net/3c527.c: * DOC: Notes

Aside from those being about the least interesting drivers in the
tree, that's pretty neat.

The docbook infrastructure probably needs to figure out a way to pick
up this stuff automatically if it's not otherwise tied in.

With Python, I can do pydoc foo.py or pydoc foo/ and immediately get
browsable extracted docs in $PAGER for the associated file or
directory. Would be nice to get a little closer to that here.

-- 
Mathematics is the supreme nostalgia of our time.
