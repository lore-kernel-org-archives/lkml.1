Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbYGYCto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbYGYCto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 22:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbYGYCtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 22:49:05 -0400
Received: from hiauly1.hia.nrc.ca ([132.246.100.193]:4376 "EHLO
	hiauly1.hia.nrc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbYGYCtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 22:49:02 -0400
X-Greylist: delayed 530 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jul 2008 22:49:01 EDT
Subject: Re: [PATCH] block: fix q->max_segment_size checking in blk_recalc_rq_segments
To: mpatocka@redhat.com (Mikulas Patocka)
Date: Thu, 24 Jul 2008 22:40:08 -0400 (EDT)
From: "John David Anglin" <dave@hiauly1.hia.nrc.ca>
Cc: James.Bottomley@HansenPartnership.com, davem@davemloft.net,
       fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-parisc@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0807241727320.12036@devserv.devel.redhat.com> from "Mikulas Patocka" at Jul 24, 2008 05:49:14 pm
X-Mailer: ELM [version 2.4 PL25]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Message-Id: <20080725024009.82A4C4DCB@hiauly1.hia.nrc.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * it is only used on two architectures, one already outdated (alpha), the 
> other being discontinued (pa-risc). On all the other architectures, 
> hw_segments == phys_segments

This "business based" argument should be ignored.  Followed to the limit,
there would only be one architecture left...

Dave
-- 
J. David Anglin                                  dave.anglin@nrc-cnrc.gc.ca
National Research Council of Canada              (613) 990-0752 (FAX: 952-6602)
