Return-Path: <linux-kernel-owner+w=401wt.eu-S1757890AbZFOQ2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890AbZFOQ2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 12:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbZFOQ2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 12:28:33 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53639 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751506AbZFOQ2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 12:28:32 -0400
Date: Mon, 15 Jun 2009 17:28:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mel Gorman <mel@csn.ul.ie>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 00/22] HWPOISON: Intro (v5)
Message-ID: <20090615172816.707bff0a@lxorguk.ukuu.org.uk>
In-Reply-To: <20090615161904.GH31969@one.firstfloor.org>
References: <20090615024520.786814520@intel.com>
	<4A35BD7A.9070208@linux.vnet.ibm.com>
	<20090615042753.GA20788@localhost>
	<Pine.LNX.4.64.0906151341160.25162@sister.anvils>
	<20090615140019.4e405d37@lxorguk.ukuu.org.uk>
	<20090615132934.GE31969@one.firstfloor.org>
	<20090615154832.73c89733@lxorguk.ukuu.org.uk>
	<20090615152427.GF31969@one.firstfloor.org>
	<20090615162804.4cb75b30@lxorguk.ukuu.org.uk>
	<20090615161904.GH31969@one.firstfloor.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 	curse a lot
> > 	suspend to disk
> > 	remove dirt from fans, clean/replace RAM
> > 	resume from disk
> > 
> > The very act of making the ECC error not take out the box creates the
> 
> Ok so at least you agree now that handling these errors without 
> panic is the right thing to do. That's at least some progress.

There are some situations it may be useful - possibly. But then if you
can't sort the resulting mess out because your patches are too limited
its not useful yet is it.

Even then this isn't 2.6.31 stuff - its 2.6.31-mm or -next stuff maybe
for 2.6.32
