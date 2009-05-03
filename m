Return-Path: <linux-kernel-owner+w=401wt.eu-S1756298AbZECPFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298AbZECPFz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 11:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbZECPFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 11:05:44 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:60655 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbZECPFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 11:05:43 -0400
Date: Sun, 3 May 2009 16:05:08 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Matthew Wilcox <matthew@wil.cx>
cc: Matthew Wilcox <willy@linux.intel.com>,
       Boaz Harrosh <bharrosh@panasas.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>,
       linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Mark Lord <lkml@rtr.ca>
Subject: Re: New TRIM/UNMAP tree published (2009-05-02)
In-Reply-To: <20090503144847.GR8822@parisc-linux.org>
Message-ID: <Pine.LNX.4.64.0905031603150.32125@blonde.anvils>
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com>
 <49D8A3D7.5070507@panasas.com> <20090503061150.GF10704@linux.intel.com>
 <20090503071619.GP8822@parisc-linux.org> <Pine.LNX.4.64.0905031346350.29671@blonde.anvils>
 <20090503144847.GR8822@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 May 2009, Matthew Wilcox wrote:
> 
> You make a good point.  There's definitely still work to be done around
> error handling.  OTOH, we could always do what IDE does ...
> 
> static void idedisk_prepare_flush(struct request_queue *q, struct request *rq)
> {
>         ide_drive_t *drive = q->queuedata;
>         struct ide_cmd *cmd = kmalloc(sizeof(*cmd), GFP_ATOMIC);
> 
>         /* FIXME: map struct ide_taskfile on rq->cmd[] */
>         BUG_ON(cmd == NULL);

Oooh, you're winding me up.  Certainly not.  Off with the Top Of your Head!

Hugh
