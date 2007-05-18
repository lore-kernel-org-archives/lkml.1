Return-Path: <linux-kernel-owner+w=401wt.eu-S1757861AbXERGd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861AbXERGd7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 02:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbXERGdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 02:33:50 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:43128 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbXERGdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 02:33:49 -0400
Date: Fri, 18 May 2007 08:16:25 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Kyle Moffett <mrmacman_g4@mac.com>
cc: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@lazybastard.org>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       linux-mtd@lists.infradead.org, Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: [PATCH] LogFS take three
In-Reply-To: <D458F595-921F-4FC0-88FC-38EEF1DCC920@mac.com>
Message-ID: <Pine.LNX.4.61.0705180813570.3231@yvahk01.tjqt.qr>
References: <20070515151919.GA32510@lazybastard.org>
 <20070515133759.9ee434a2.akpm@linux-foundation.org> <20070516000630.GD1220@lazybastard.org>
 <Pine.LNX.4.61.0705171920330.3231@yvahk01.tjqt.qr> <20070517174532.GA26827@2ka.mipt.ru>
 <D458F595-921F-4FC0-88FC-38EEF1DCC920@mac.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 17 2007 21:00, Kyle Moffett wrote:
>> > > Opinions?
>> > 
>> > Why would we need another btree, when there is lib/rbtree.c?  Or does
>> > yours do something fundamentally different?
>> 
>> It is not red-black tree, it is b+ tree.
>
> It might be better to use the prefix "bptree" to help prevent confusion.  A
> quick google search on "bp-tree" reveals only the perl B+-tree module
> "Tree::BPTree", a U-Maryland Java CS project on B+-trees, and a news article
> about a "BP tree-top protest".

BP heh.. How about "struct bplustree"?


	Jan
-- 
