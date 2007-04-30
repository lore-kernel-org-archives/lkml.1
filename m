Return-Path: <linux-kernel-owner+w=401wt.eu-S1946890AbXD3X1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946890AbXD3X1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 19:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946894AbXD3X1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 19:27:46 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:57196 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946892AbXD3X1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 19:27:43 -0400
Date: Mon, 30 Apr 2007 16:23:51 -0700
From: Bill Irwin <bill.irwin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: bunk@stusta.de, akpm@osdl.org, gcoady@gmail.com, zlynx@acm.org,
       dgc@sgi.com, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org,
       hch@infradead.org, wli@holomorphy.com, jengelh@linux01.gwdg.de,
       bill.irwin@oracle.com, zwane@infradead.org, neilb@suse.de,
       jens.axboe@oracle.com, eric@provenscaling.com
Subject: [0/3] i386 stack handling updates
Message-ID: <20070430232351.GG26598@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	linux-kernel@vger.kernel.org, bunk@stusta.de, akpm@osdl.org,
	gcoady@gmail.com, zlynx@acm.org, dgc@sgi.com,
	alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, hch@infradead.org,
	jengelh@linux01.gwdg.de, zwane@infradead.org, neilb@suse.de,
	jens.axboe@oracle.com, eric@provenscaling.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a series of patches to improve i386 stack handling in several
manners. The net result is to improve system stability via IRQ stacks
while remaining memory efficient and to improve stack debugging.

[1/3] dynamically allocate irq stacks
	This conserves memory while using IRQ stacks.
[2/3] make irqstacks unconditional, while retaining 4/8k stack selection
	This makes IRQ stacks the standard for mainline.
[3/3] DEBUG_STACK option enabling vmalloc()'ed stacks and __pa checks
	Stack debugging option using vmalloc() to establish guard pages.


-- wli
