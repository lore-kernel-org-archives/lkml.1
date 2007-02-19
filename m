Return-Path: <linux-kernel-owner+w=401wt.eu-S965549AbXBSXew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965549AbXBSXew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 18:34:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965551AbXBSXew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 18:34:52 -0500
Received: from THUNK.ORG ([69.25.196.29]:38492 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965549AbXBSXev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 18:34:51 -0500
Date: Mon, 19 Feb 2007 18:34:40 -0500
From: Theodore Tso <tytso@mit.edu>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/44 take 2] [UBI] Unsorted Block Images
Message-ID: <20070219233440.GC5691@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Artem Bityutskiy <dedekind@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Frank Haverkamp <haver@vnet.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	David Woodhouse <dwmw2@infradead.org>,
	Josh Boyer <jwboyer@linux.vnet.ibm.com>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <20070217224952.GB16522@thunk.org> <1171889303.13817.29.camel@sauron> <20070219143321.GE25490@thunk.org> <1171904866.14817.36.camel@sauron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171904866.14817.36.camel@sauron>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 19, 2007 at 07:07:46PM +0200, Artem Bityutskiy wrote:
> I just used different concept: one looks at declaration and the overall
> picture becomes clear because _there is_ documentation. One does not
> look at the implementation to grasp picture on surface.
> 
> But your point is fair. I assume _programmers_ look in .c first. Users
> may always generate a pdf. I will do what you advise.

First of all, you are writing kernel code for programmers, not end-users.

Secondly, and this is a big issue, you haven't specified which "units"
are exporting interfaces that will be used outside of UBI, and which
are being used only internally inside UBI.  Interfaces which will be
used outside of UBI have to be carefully controlled.  Interfaces only
used inside UBI are private interfaces which can be easily changed.

Also, if you are going to use this horrible, theoretical, pendantic
Computer Science coding stlye, at the very least you should have
included a module dependency diagram so it was easy to understand what
the heck was going on.  This would make it easier to make specific
suggestions, because after I looked at it for a while, I decided it
was too hard to figure out the overall architecture, and not worth my
time, and so I gave up on the review.  Not that my opinion is the only
one you need to pay attention to, but if everyone is telling you that
need to simplify the number of interfaces, you may want to listen
since your code is going to need adequate review if you want to get it
into mainline.

						- Ted
