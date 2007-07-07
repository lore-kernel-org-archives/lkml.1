Return-Path: <linux-kernel-owner+w=401wt.eu-S1753929AbXGGQWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929AbXGGQWm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 12:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbXGGQWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 12:22:34 -0400
Received: from canuck.infradead.org ([209.217.80.40]:35292 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbXGGQWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 12:22:34 -0400
Subject: Re: 2.6.22-rc7: known regressions with patches v2
From: David Woodhouse <dwmw2@infradead.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@stusta.de>,
       Patrick Caulfield <pcaulfie@redhat.com>,
       David Teigland <teigland@redhat.com>, bluez-devel@lists.sourceforge.net,
       Marcel Holtmann <marcel@holtmann.org>, Jiri Kosina <jkosina@suse.cz>,
       Dmitry Torokhov <dtor@insightbb.com>
In-Reply-To: <468FBA20.8060509@googlemail.com>
References: <468FBA20.8060509@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Date: Sat, 07 Jul 2007 12:23:11 -0400
Message-Id: <1183825391.3066.59.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-07 at 18:06 +0200, Michal Piotrowski wrote:
> FBDEV
> 
> Subject         : SLUB kmalloc-32768: Poison check failed@0xc1e20000
> slab 0xc04de400
> References      : http://lkml.org/lkml/2007/7/4/305
> Last known good : ?
> Submitter       : David Woodhouse <dwmw2@infradead.org>
> Caused-By       : ?
> Handled-By      : ?
> Status          : unknown

If you're looking for someone to blame, consider the fact that this has
gone away now I've switched back to slab. :)

> Bluetooth
> 
> Subject         : problem with a bluetooth mouse
> References      : http://lkml.org/lkml/2007/7/4/321
> Last known good : ?
> Submitter       : David Woodhouse <dwmw2@infradead.org>
> Caused-By       : ?
> Handled-By      : Jiri Kosina <jkosina@suse.cz>
>                   Dmitry Torokhov <dtor@insightbb.com>
> Patch           : http://lkml.org/lkml/2007/7/6/391
> Status          : patch available

That patch was a straw man for Marcel to comment on, not necessarily a
real fix. I don't know the code that well, and naïvely reordering bits
of it could have introduced another race which I just haven't triggered
yet.

Strictly speaking, it wasn't a 2.6.22 regression either -- I actually
saw it for the first time in 2.6.21-rc iirc.

Thanks for tracking these, btw. It's very useful.

-- 
dwmw2

