Return-Path: <linux-kernel-owner+w=401wt.eu-S1759631AbXEQRl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759631AbXEQRl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 13:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758997AbXEQRlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 13:41:07 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:35063 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758752AbXEQRlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 13:41:05 -0400
Date: Thu, 17 May 2007 19:26:07 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: [PATCH] LogFS take three
In-Reply-To: <20070516000630.GD1220@lazybastard.org>
Message-ID: <Pine.LNX.4.61.0705171920330.3231@yvahk01.tjqt.qr>
References: <20070515151919.GA32510@lazybastard.org>
 <20070515133759.9ee434a2.akpm@linux-foundation.org> <20070516000630.GD1220@lazybastard.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 16 2007 02:06, Jörn Engel wrote:
>
>> > +/* memtree.c */
>> > +void btree_init(struct btree_head *head);
>> > +void *btree_lookup(struct btree_head *head, long val);
>> > +int btree_insert(struct btree_head *head, long val, void *ptr);
>> > +int btree_remove(struct btree_head *head, long val);
>> 
>> These names are too generic.  If we later add a btree library: blam.
>
>My plan was to move this code to lib/ sooner or later.  If you consider
>it useful in its current state, I can do it immediatly.  And if someone
>else merged a superior btree library I'd happily remove mine and use the
>new one instead.
>
>Opinions?

Why would we need another btree, when there is lib/rbtree.c?
Or does yours do something fundamentally different?


	Jan
-- 
