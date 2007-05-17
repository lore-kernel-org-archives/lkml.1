Return-Path: <linux-kernel-owner+w=401wt.eu-S1760172AbXEQRrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760172AbXEQRrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 13:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759910AbXEQRra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 13:47:30 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:52876 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759778AbXEQRr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 13:47:27 -0400
Date: Thu, 17 May 2007 21:45:33 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: [PATCH] LogFS take three
Message-ID: <20070517174532.GA26827@2ka.mipt.ru>
References: <20070515151919.GA32510@lazybastard.org> <20070515133759.9ee434a2.akpm@linux-foundation.org> <20070516000630.GD1220@lazybastard.org> <Pine.LNX.4.61.0705171920330.3231@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0705171920330.3231@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Thu, 17 May 2007 21:45:52 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 07:26:07PM +0200, Jan Engelhardt (jengelh@linux01.gwdg.de) wrote:
> >My plan was to move this code to lib/ sooner or later.  If you consider
> >it useful in its current state, I can do it immediatly.  And if someone
> >else merged a superior btree library I'd happily remove mine and use the
> >new one instead.
> >
> >Opinions?
> 
> Why would we need another btree, when there is lib/rbtree.c?
> Or does yours do something fundamentally different?

It is not red-black tree, it is b+ tree.

> 	Jan

-- 
	Evgeniy Polyakov
