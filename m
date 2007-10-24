Return-Path: <linux-kernel-owner+w=401wt.eu-S1756392AbXJXLjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392AbXJXLjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 07:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756341AbXJXLje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 07:39:34 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54489 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755711AbXJXLjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 07:39:33 -0400
Message-ID: <471F2EF2.9080304@garzik.org>
Date: Wed, 24 Oct 2007 07:39:30 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: FUJITA Tomonori <tomof@acm.org>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH -mm 10/11] sata_inic162x: use pci_set_dma_max_seg_size
References: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org> <20071024172847R.tomof@acm.org>
In-Reply-To: <20071024172847R.tomof@acm.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> This sets the segment size limit properly via pci_set_dma_max_seg_size
> and remove blk_queue_max_segment_size because scsi-ml calls it.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/ata/sata_inic162x.c |   25 +++++++++++++------------
>  1 files changed, 13 insertions(+), 12 deletions(-)

ACK


