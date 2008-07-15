Return-Path: <linux-kernel-owner+w=401wt.eu-S1762213AbYGORgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762213AbYGORgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 13:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756416AbYGORgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 13:36:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52868 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648AbYGORgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 13:36:31 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: david@lang.hm, Frans Pop <elendil@planet.nl>, jeff@garzik.org,
       arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0807150936070.3017@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <20080714164119.99c33d5b.akpm@linux-foundation.org>
	 <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>
	 <487C0365.5030203@garzik.org>
	 <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
	 <200807151757.10626.elendil@planet.nl>
	 <alpine.LFD.1.10.0807150913590.3017@woody.linux-foundation.org>
	 <alpine.DEB.1.10.0807150931290.16109@asgard.lang.hm>
	 <alpine.LFD.1.10.0807150936070.3017@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 10:36:01 -0700
Message-Id: <1216143361.27455.294.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 09:41 -0700, Linus Torvalds wrote:
> So I think the _infrastructure_ is important. But the extreme "you
> have to split it off entirely" mindset is equally as stupid as the
> "you must compile it into the module" mindset.

I wouldn't necessarily argue that we _have_ to split it off, but I'd
certainly like our infrastructure to be mature enough that it could cope
with doing so.

I plan to make a 'linux-firmware-from-linus' git tree which is generated
automatically from yours by a script, much like the kernel-headers git
tree is, commit by commit with an automatic transform on the tree
objects.

Once we have that tree being created, we could pull from it into a
canonical 'linux-firmware' tree, and _that_ tree could also start to
include firmware belonging to companies who have said that we may
distribute their firmware, but _not_ as part of the Linux kernel.

We can see how that tree works out in practice, and how/whether people
start using it. And then maybe we'll be in a position to have a
_discussion_ about how best to ship the firmware. But for now it's
premature.
 
-- 
dwmw2

