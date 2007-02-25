Return-Path: <linux-kernel-owner+w=401wt.eu-S964786AbXBYKmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964786AbXBYKmr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 05:42:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964791AbXBYKmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 05:42:46 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:40277 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964786AbXBYKmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 05:42:43 -0500
Date: Sun, 25 Feb 2007 11:42:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Theodore Tso <tytso@mit.edu>, Artem Bityutskiy <dedekind@infradead.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 05/44 take 2] [UBI] internal common header
Message-ID: <20070225104233.GC2045@elf.ucw.cz>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <20070217165449.5845.18238.sendpatchset@localhost.localdomain> <20070219105445.GA16930@infradead.org> <1171976753.4039.27.camel@sauron> <20070220145503.GC3170@thunk.org> <1171984555.3518.5.camel@hades.cambridge.redhat.com> <20070220152259.GD3170@thunk.org> <1171985598.3518.8.camel@hades.cambridge.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171985598.3518.8.camel@hades.cambridge.redhat.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2007-02-20 15:33:18, David Woodhouse wrote:
> On Tue, 2007-02-20 at 10:22 -0500, Theodore Tso wrote:
> > But __be32 will catch the same errors these days because the be/le
> > types use __bitwise now, right?  So use of the __be32/__be64 types should
> > be preferred since it also will work with sparse, I would think.
> 
> Does __bitwise work in gcc? I thought it was only for sparse?

Hmm... if you have superior endian-debugging infrastructure, perhaps
you should just move rest of kernel to it? Having two endian-debugging
infrastructures is ugly...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
