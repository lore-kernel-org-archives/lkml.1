Return-Path: <linux-kernel-owner+w=401wt.eu-S1754805AbYGXP3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbYGXP3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 11:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbYGXP2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 11:28:54 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43183 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752662AbYGXP2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 11:28:52 -0400
Subject: Re: [PATCH] block: fix q->max_segment_size checking in
	blk_recalc_rq_segments about VMERGE
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: David Miller <davem@davemloft.net>, fujita.tomonori@lab.ntt.co.jp,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-parisc@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0807241103190.1545@devserv.devel.redhat.com>
References: <1216520228.3376.33.camel@localhost.localdomain>
	 <20080719.210737.197246608.davem@davemloft.net>
	 <1216565545.4199.10.camel@localhost.localdomain>
	 <20080720.102302.137955996.davem@davemloft.net>
	 <1216575211.4199.35.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0807241103190.1545@devserv.devel.redhat.com>
Content-Type: text/plain
Date: Thu, 24 Jul 2008 11:28:34 -0400
Message-Id: <1216913314.4524.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-24 at 11:07 -0400, Mikulas Patocka wrote:
> So try to #define BIO_VMERGE_BOUNDARY 0 for Pa-Risc and tell us what 
> performance degradation do you see (and what driver do you use and what is 
> the I/O pattern).
> 
> If you show something specific, we can consider that --- but you haven't 
> yet told us anything, except generic talk.

You keep ignoring inconvenient facts.  For about the third time:

I run a test bed for sg_tables (large chaining of requests).  This runs
on parisc using virtual merging (has to because the final physical table
size can't go over the sg list of the SCSI card).  If I turn off virtual
merging I can no longer test sg_tables in vanilla kernels.

James


