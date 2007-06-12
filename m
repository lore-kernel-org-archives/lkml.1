Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbXFLBFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbXFLBFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 21:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbXFLBFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 21:05:16 -0400
Received: from ozlabs.org ([203.10.76.45]:45696 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754262AbXFLBFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 21:05:14 -0400
Subject: Re: [PATCH 1/9] readahead: introduce PG_readahead
From: Rusty Russell <rusty@rustcorp.com.au>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Jens Axboe <jens.axboe@oracle.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Pratt <slpratt@austin.ibm.com>,
       Ram Pai <linuxram@us.ibm.com>
In-Reply-To: <20070516224818.246719596@mail.ustc.edu.cn>
References: <20070516224752.500812933@mail.ustc.edu.cn>
	 <20070516224818.246719596@mail.ustc.edu.cn>
Content-Type: text/plain
Date: Tue, 12 Jun 2007 11:04:54 +1000
Message-Id: <1181610294.16428.133.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-17 at 06:47 +0800, Fengguang Wu wrote:
> plain text document attachment (mm-introduce-pg_readahead.patch)
> Introduce a new page flag: PG_readahead.
> 
> It acts as a look-ahead mark, which tells the page reader:
> Hey, it's time to invoke the read-ahead logic.  For the sake of I/O pipelining,
> don't wait until it runs out of cached pages!

Hi Fengguang!

	I've been reading your patches, and I have some (possibly dumb!)
questions.

For this patch: why set a bit in the page, rather than keep a value
inside the "struct file_ra_state"?

Thanks,
Rusty.


