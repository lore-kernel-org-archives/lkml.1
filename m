Return-Path: <linux-kernel-owner+w=401wt.eu-S1751654AbZCPBkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbZCPBkF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 21:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbZCPBjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 21:39:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:53589 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbZCPBjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 21:39:53 -0400
Message-ID: <49BDADC3.6030809@kernel.org>
Date: Mon, 16 Mar 2009 10:39:15 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Jens Axboe <jens.axboe@oracle.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Mike Miller <mike.miller@hp.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jeff Garzik <jgarzik@pobox.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 11/14] block: implement and use [__]blk_end_request_all()
References: <1236920578-2179-1-git-send-email-tj@kernel.org> <200903152134.46385.bzolnier@gmail.com> <20090315204802.GH27476@kernel.dk> <200903152234.42274.bzolnier@gmail.com>
In-Reply-To: <200903152234.42274.bzolnier@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 16 Mar 2009 01:39:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Bart, Jens.

Bartlomiej Zolnierkiewicz wrote:
> pata tree is based on Linus' tree _not_ on linux-next and this is very
> handy when it comes to preparing pull requests.
> 
> It could be that I worry needlessly but with ~170 patches in the tree
> currently, lack of time and merge window around the corner there is
> no wonder that I'm reluctant to any experiments.  However I completely
> agree that we should look into the ways of improving the process in
> the longer-term.

quilt tree is fine for leaf tree changes but problems occur when other
changes need to be based off the tree as is the case here.  Is it
possible for you to provide mid-synchronization git commits?  It means
starting up a new quilt tree after each synchronization point (as rc1
merge points would) but it could be an acceptable mid-point for both
trees if the number of sync points aren't too many.

Thanks.

-- 
tejun
