Return-Path: <linux-kernel-owner+w=401wt.eu-S1759958AbYGOFi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759958AbYGOFi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 01:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754368AbYGOFiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 01:38:17 -0400
Received: from 1wt.eu ([62.212.114.60]:3992 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758064AbYGOFiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 01:38:16 -0400
Date: Tue, 15 Jul 2008 07:36:49 +0200
From: Willy Tarreau <w@1wt.eu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel, use it in more drivers.
Message-ID: <20080715053649.GK1369@1wt.eu>
References: <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org> <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org> <487C09EB.1050903@garzik.org> <alpine.LFD.1.10.0807141928540.3017@woody.linux-foundation.org> <487C1648.5070409@garzik.org> <alpine.LFD.1.10.0807142027140.3017@woody.linux-foundation.org> <20080715050654.GH1369@1wt.eu> <1216099930.27455.205.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216099930.27455.205.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2008 at 10:32:10PM -0700, David Woodhouse wrote:
> On Tue, 2008-07-15 at 07:06 +0200, Willy Tarreau wrote:
> > This is just a matter of point of view. From my POV, having to feed
> > several unrelated files into a system to be able to get it to support
> > any device is moving backwards, compared to the currently clean
> > all-in-1 driver model.
> 
> So you disapprove of having to load mac80211.ko before your wireless NIC
> driver?

for this one, I don't know, as it is typically something which might
be installed without me noticing.

> Or sungem_phy.ko before sungem.ko?

that one might be more annoying, however, having the same name and being
in the same directory as its brother makes it quite obvious. The ones
which had already caught me were mii, crc32, etc...

> Or libphy.ko before various other drivers?

cf above.

> Or having to install /sbin/modprobe before you can load modules?

David, please do not exagerate. I hoped you were able to see the
difference between being lazy and encountering difficulties to
set up a system.

Willy

