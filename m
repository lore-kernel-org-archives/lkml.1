Return-Path: <linux-kernel-owner+w=401wt.eu-S1423166AbXD3JAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423166AbXD3JAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 05:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423173AbXD3JAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 05:00:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48836 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423166AbXD3I7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 04:59:48 -0400
Date: Mon, 30 Apr 2007 09:59:16 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Neil Brown <neilb@suse.de>
Cc: Zan Lynx <zlynx@acm.org>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [-mm patch] i386: enable 4k stacks by default
Message-ID: <20070430085916.GA31397@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Neil Brown <neilb@suse.de>, Zan Lynx <zlynx@acm.org>,
	Adrian Bunk <bunk@stusta.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070428191927.GN3468@stusta.de> <1177795118.7828.6.camel@localhost> <17973.44824.631204.926723@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17973.44824.631204.926723@notabene.brown>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 06:55:52PM +1000, Neil Brown wrote:
> On Saturday April 28, zlynx@acm.org wrote:
> > On Sat, 2007-04-28 at 21:19 +0200, Adrian Bunk wrote:
> > > 4k stacks have become a well-tested feature used fore a long time in
> > > Fedora and even in RHEL 4.
> > 
> > So has anyone fixed the bugs involving ext3 and LVM snapshots on top of
> > DM mirror?
> 
> Well -mm has a patch which makes stacked block devices much less of an
> issue, but this hasn't made it -linus yet - I think the dm developer
> isn't happy that dm works properly with it.

I get a little tired about this objection.  If the particular dm code
was racy before and this can in theory make it worse it's their problem,
and putting in perfectly fine code will give them an incentive to
fix their year old race.

