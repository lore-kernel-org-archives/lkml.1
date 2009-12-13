Return-Path: <linux-kernel-owner+w=401wt.eu-S1752501AbZLMRvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbZLMRvq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 12:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbZLMRvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 12:51:46 -0500
Received: from waste.org ([173.11.57.241]:38107 "HELO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751458AbZLMRvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 12:51:45 -0500
X-Greylist: delayed 605 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Dec 2009 12:51:35 EST
Date: Sun, 13 Dec 2009 11:41:27 -0600
From: Matt Mackall <mpm@selenic.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Diego Calleja <diegocg@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Convert Documentation/ to asciidoc?
Message-ID: <20091213174127.GR8789@waste.org>
References: <200912131638.55549.diegocg@gmail.com> <20091213092930.9071d926.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091213092930.9071d926.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 13, 2009 at 09:29:30AM -0800, Randy Dunlap wrote:
> On Sun, 13 Dec 2009 16:38:55 +0100 Diego Calleja wrote:
> 
> > Git uses asciidoc, tools/perf/Documentation uses asciidoc... It seems
> > a good fit for Documentation/. Is there any objection against it?
> > --
> 
> I think I'd like to see it, but I can only say for sure after
> I see the results.  OTOH, Matt Mackall didn't care for it the
> last time that this was brought up.

Mercurial adopted asciidoc early on, and our experience with it wasn't
great - it had many difficult to work around quirks. We eventually
built our own parser for a subset of 'restructured text' to generate
our help messages and build our docs.

I think if we're going to go down a mark-up road for Documentation/,
we're going to need to roll our own tool and make it aware of
kerneldoc and so forth.

-- 
Mathematics is the supreme nostalgia of our time.
