Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbYLKAji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbYLKAji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 19:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbYLKAj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 19:39:27 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54448 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbYLKAj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 19:39:27 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [bug?] bio: add experimental support for inlining a number of bio_vecs inside the bio
Cc: kosaki.motohiro@jp.fujitsu.com, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081210121237.GQ23742@kernel.dk>
References: <20081210204630.4FE3.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081210121237.GQ23742@kernel.dk>
Message-Id: <20081211093620.4FE8.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 11 Dec 2008 09:39:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > experimental??
> 
> Experimental in the sense that it's the first version, not the concept.
> It's held up well for me, but just yesterday I received the first bug
> report on a ppc platform and now you have this on ia64. Can you pin
> point where in __blk_complete_request() it dies with the NULL pointer
> deref? I'm assuming you don't have CONFIG_FAIL_IO_TIMEOUT set, otherwise
> I don't see how it could fail. So that looks like req->q being NULL,
> which doesn't have much relation to this.
> 
> Can you try with slab and pagealloc debugging options switched on? The
> above looks like a side effect of some badness there.

Yes, I don't set CONFIG_FAIL_IO_TIMEOUT.
However, your memory corruption fixing patch solve my problem too.

	http://marc.info/?l=linux-kernel&m=122891947725303&w=2


Thanks.


