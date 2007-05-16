Return-Path: <linux-kernel-owner+w=401wt.eu-S1760693AbXEPM2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760693AbXEPM2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 08:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757465AbXEPM2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 08:28:32 -0400
Received: from mail.shareable.org ([81.29.64.88]:36241 "EHLO
	mail.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756824AbXEPM2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 08:28:31 -0400
Date: Wed, 16 May 2007 13:25:48 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>, akpm@osdl.org,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Albert Cahalan <acahalan@gmail.com>, Greg KH <greg@kroah.com>,
       John Stoffel <john@stoffel.org>, linux-kernel@vger.kernel.org,
       Ingo Oeser <ioe-lkml@rameria.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-mtd@lists.infradead.org, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] LogFS take three
Message-ID: <20070516122548.GA25239@mail.shareable.org>
References: <20070515151919.GA32510@lazybastard.org> <17994.1241.436841.681216@stoffel.org> <20070515191926.GB1220@lazybastard.org> <1179291255.2859.195.camel@shinybook.infradead.org> <20070516110933.GA5472@lazybastard.org> <20070516113434.GC20482@mail.shareable.org> <1179315498.3642.19.camel@sauron>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1179315498.3642.19.camel@sauron>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy wrote:
> On Wed, 2007-05-16 at 12:34 +0100, Jamie Lokier wrote:
> > Jörn Engel wrote:
> > > On Wed, 16 May 2007 12:54:14 +0800, David Woodhouse wrote:
> > > > Personally I'd just go for 'JFFS3'. After all, it has a better claim to
> > > > the name than either of its predecessors :)
> > > 
> > > Did you ever see akpm's facial expression when he tried to pronounce
> > > "JFFS2"?  ;)
> > 
> > JFFS3 is a good, meaningful name to anyone familiar with JFFS2.
> > 
> > But if akpm can't pronounce it, how about FFFS for faster flash
> > filesystem.... ;-)
> 
> The problem is that JFFS2 will always be faster in terms of I/O speed
> anyway, just because it does not have to maintain on-flash indexing
> data structures. But yes, it is slow in mount and in building big
> inodes, so the "faster" is confusing.

Is LogFS really slower than JFFS2 in practice?

I would have guessed reads to be a similar speed, tree updates to be a
similar speed  to journal  updates for sustained  non-fsyncing writes,
and the difference unimportant for tiny individual commits whose index
updates are not merged with any other.  I've not thought about it much
though.

-- Jamie
