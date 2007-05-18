Return-Path: <linux-kernel-owner+w=401wt.eu-S1761272AbXERBDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761272AbXERBDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 21:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757335AbXERBDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 21:03:05 -0400
Received: from smtpout.mac.com ([17.250.248.185]:49586 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755110AbXERBDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 21:03:04 -0400
In-Reply-To: <20070517174532.GA26827@2ka.mipt.ru>
References: <20070515151919.GA32510@lazybastard.org> <20070515133759.9ee434a2.akpm@linux-foundation.org> <20070516000630.GD1220@lazybastard.org> <Pine.LNX.4.61.0705171920330.3231@yvahk01.tjqt.qr> <20070517174532.GA26827@2ka.mipt.ru>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <D458F595-921F-4FC0-88FC-38EEF1DCC920@mac.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       linux-mtd@lists.infradead.org, Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] LogFS take three
Date: Thu, 17 May 2007 21:00:44 -0400
To: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@lazybastard.org>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On May 17, 2007, at 13:45:33, Evgeniy Polyakov wrote:
> On Thu, May 17, 2007 at 07:26:07PM +0200, Jan Engelhardt  
> (jengelh@linux01.gwdg.de) wrote:
>>> My plan was to move this code to lib/ sooner or later.  If you  
>>> consider it useful in its current state, I can do it immediatly.   
>>> And if someone else merged a superior btree library I'd happily  
>>> remove mine and use the new one instead.
>>>
>>> Opinions?
>>
>> Why would we need another btree, when there is lib/rbtree.c?  Or  
>> does yours do something fundamentally different?
>
> It is not red-black tree, it is b+ tree.

It might be better to use the prefix "bptree" to help prevent  
confusion.  A quick google search on "bp-tree" reveals only the perl B 
+-tree module "Tree::BPTree", a U-Maryland Java CS project on B+- 
trees, and a news article about a "BP tree-top protest".

Cheers,
Kyle Moffett

