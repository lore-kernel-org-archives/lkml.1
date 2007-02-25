Return-Path: <linux-kernel-owner+w=401wt.eu-S933665AbXBYFzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933665AbXBYFzY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 00:55:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933669AbXBYFzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 00:55:24 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60500 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933665AbXBYFzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 00:55:23 -0500
Date: Sun, 25 Feb 2007 05:55:22 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/44 take 2] [UBI] Unsorted Block Images
Message-ID: <20070225055522.GB9137@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Artem Bityutskiy <dedekind@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Frank Haverkamp <haver@vnet.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	David Woodhouse <dwmw2@infradead.org>,
	Josh Boyer <jwboyer@linux.vnet.ibm.com>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <20070219105009.GA15792@infradead.org> <1171907056.14817.70.camel@sauron>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171907056.14817.70.camel@sauron>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 19, 2007 at 07:44:16PM +0200, Artem Bityutskiy wrote:
> On Mon, 2007-02-19 at 10:50 +0000, Christoph Hellwig wrote:
> > I think this is the wrong approach.  For one thing the unit terms is
> > rather foregin in Linux
> 
> I would rather disagree. Subjective. Unit is a generic word, just like
> subsystem. Unit-tests for example is a widespread word it refer to
> internal units of a big system.

What I meant is that we currently do not use the 'unit' term for code
modules in the linux kernel at all.  

> Please, refine what does this exactly mean. I do not see how I should
> have sent it, sorry. OK, I've separated external headers, JFFS2 support,
> build stuff. What next?

You should not separate more but less.  Generelly the review-"unit"
should be a functionally separate kenrel module, not microscopic pieces
of it.  Unfortunately there are mailinglist limitations why we sometimes
have to split things up a little further, but it's usually really hard
to do useful splits at this boundary.

