Return-Path: <linux-kernel-owner+w=401wt.eu-S1752612AbYGTEHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbYGTEHs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 00:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750702AbYGTEHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 00:07:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57746
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750701AbYGTEHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 00:07:37 -0400
Date: Sat, 19 Jul 2008 21:07:37 -0700 (PDT)
Message-Id: <20080719.210737.197246608.davem@davemloft.net>
To: James.Bottomley@HansenPartnership.com
Cc: mpatocka@redhat.com, fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-parisc@vger.kernel.org
Subject: Re: [PATCH] block: fix q->max_segment_size checking in
 blk_recalc_rq_segments about VMERGE
From: David Miller <davem@davemloft.net>
In-Reply-To: <1216520228.3376.33.camel@localhost.localdomain>
References: <20080719.002826.73806419.davem@davemloft.net>
	<Pine.LNX.4.64.0807192141500.13523@devserv.devel.redhat.com>
	<1216520228.3376.33.camel@localhost.localdomain>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Sat, 19 Jul 2008 21:17:08 -0500

> Try this patch

I'd rather remove the vmerge code, it doesn't buy us
anything, and for something so complex and so hard to
keep working correctly it's existence is far from
justified these days.
