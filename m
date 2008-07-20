Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979AbYGTFzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbYGTFzH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 01:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbYGTFy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 01:54:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59532
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751295AbYGTFy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 01:54:56 -0400
Date: Sat, 19 Jul 2008 22:54:56 -0700 (PDT)
Message-Id: <20080719.225456.263046335.davem@davemloft.net>
To: mpatocka@redhat.com
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-parisc@vger.kernel.org
Subject: Re: [PATCH] block: fix q->max_segment_size checking in
 blk_recalc_rq_segments about VMERGE
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0807192141500.13523@devserv.devel.redhat.com>
References: <20080717221908D.fujita.tomonori@lab.ntt.co.jp>
	<20080719.002826.73806419.davem@davemloft.net>
	<Pine.LNX.4.64.0807192141500.13523@devserv.devel.redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>
Date: Sat, 19 Jul 2008 21:45:11 -0400 (EDT)

> Few days ago I created this.
> 
> Another task would be to remove nr_hw_segments from request, bio and queue 
> parameters (if this patch is accepted).

I'm fine with this:

Acked-by: David S. Miller <davem@davemloft.net>
