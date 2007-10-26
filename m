Return-Path: <linux-kernel-owner+w=401wt.eu-S1761784AbXJZOqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761784AbXJZOqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 10:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbXJZOqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 10:46:32 -0400
Received: from waste.org ([66.93.16.53]:39903 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbXJZOqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 10:46:31 -0400
Date: Fri, 26 Oct 2007 09:46:09 -0500
From: Matt Mackall <mpm@selenic.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, sam@ravnborg.org
Subject: Re: [PATCH 0/6] kernel-doc: add DOC: sections support
Message-ID: <20071026144609.GX19691@waste.org>
References: <11932637282902@xenotime.net> <20071025172932.GN17536@waste.org> <20071025103611.f2ae216f.rdunlap@xenotime.net> <20071025192145.GQ19691@waste.org> <1193395697.4406.56.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193395697.4406.56.camel@johannes.berg>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 12:48:17PM +0200, Johannes Berg wrote:
> 
> > > ./drivers/net/3c527.c: * DOC: Notes
> > 
> > Aside from those being about the least interesting drivers in the
> > tree, that's pretty neat.
> > 
> > The docbook infrastructure probably needs to figure out a way to pick
> > up this stuff automatically if it's not otherwise tied in.
> 
> The 5th and 6th patch in this series do that by allowing you to write
> 
> !Pfilename section title
> 
> in a docbook template file to insert the contents of such a section.
> It's what I'm doing for mac80211's docs so that browsing the files gives
> you the same documentation as reading the mac80211 docbook book just
> organised differently.

There are lots and lots of files that currently contain kerneldoc
comments that are unreferenced by docbook (and have been for years).
We should somehow sweep them all up into some sort of bucket
automatically.

-- 
Mathematics is the supreme nostalgia of our time.
