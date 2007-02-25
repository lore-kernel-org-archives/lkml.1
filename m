Return-Path: <linux-kernel-owner+w=401wt.eu-S933666AbXBYFvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933666AbXBYFvm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 00:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933668AbXBYFvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 00:51:42 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48705 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933666AbXBYFvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 00:51:41 -0500
Date: Sun, 25 Feb 2007 05:51:39 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: Theodore Tso <tytso@mit.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/44 take 2] [UBI] Unsorted Block Images
Message-ID: <20070225055139.GA9137@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Artem Bityutskiy <dedekind@infradead.org>,
	Theodore Tso <tytso@mit.edu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Frank Haverkamp <haver@vnet.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	David Woodhouse <dwmw2@infradead.org>,
	Josh Boyer <jwboyer@linux.vnet.ibm.com>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <20070217224952.GB16522@thunk.org> <1171889303.13817.29.camel@sauron> <20070219143321.GE25490@thunk.org> <1171904866.14817.36.camel@sauron>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171904866.14817.36.camel@sauron>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 19, 2007 at 07:07:46PM +0200, Artem Bityutskiy wrote:
> > And when you create that many interfaces, it adds inertia to changing
> > the interfaces later on, because it's sometimes not clear how many
> > users of the interface there really are.  My general rule of thumb is
> > that if an interface only has one user, then it may be a good idea to
> > combine it with the user of that interface, and then make the
> > functions involved be a static, so that it becomes clear the only user
> > of that functoin is within that one file.  You can take this too far,
> > and to extremes it doesn't work all that well, but the UBI layer has
> > gone waaaaaay off the deep end in terms of functional decomposition.
> 
> Well... I do not want any flame on this topic. It is about taste,
> trade-offs, compromises. It is difficult to provide _objective_ and
> killing arguments here. But I will think on this, point taken, thanks.

Codingstyle is and always will be about tastes, but it usually helps a lot
if you try to understand and follow the style of the project you want
to contribute to :)
