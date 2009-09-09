Return-Path: <linux-kernel-owner+w=401wt.eu-S1753817AbZIIQuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbZIIQuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 12:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbZIIQuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 12:50:21 -0400
Received: from baron.coraid.com ([12.51.113.4]:48543 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752249AbZIIQuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 12:50:21 -0400
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Wed, 9 Sep 2009 12:50:12 -0400
To: ecashin@coraid.com, jens.axboe@oracle.com, akpm@linux-foundation.org,
       apw@canonical.com, bonbons@linux-vserver.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aoe: end barrier bios with EOPNOTSUPP
Message-ID: <61768ed9922a0f0bb1af3e1fe14bde00@coraid.com>
In-Reply-To: <60772f633c524ba873f569966fccd6ce@coraid.com>
References: <200909021955.n82JtkrI032267@imap1.linux-foundation.org>
	<20090903063539.GH12579@kernel.dk>
	<2339aa04a4e8fb440a52624273728352@coraid.com>
	<20090904183525.GB18599@kernel.dk>
	<f48e25c99e41e375f2ddd85989cd39e1@coraid.com>
	<20090905051735.GH18599@kernel.dk>
	<366469f19c41e0150028b886f6859019@coraid.com>
	<20090908193540.GB18599@kernel.dk>
	<60772f633c524ba873f569966fccd6ce@coraid.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed Sep  9 12:45:17 EDT 2009, ecashin@coraid.com wrote:
...
> +	} else if (bio_barrier(bio)) {
> +                bio_endio(bio, -EOPNOTSUPP);
> +                return 0;
>  	} else if (bio->bi_io_vec == NULL) {
>  		printk(KERN_ERR "aoe: bi_io_vec is NULL\n");
>  		BUG();

Bah.  I should have run checkpatch.pl.  I will re-do this patch using
real tabs.

-- 
  Ed
