Return-Path: <linux-kernel-owner+w=401wt.eu-S1757719AbYGCXw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757719AbYGCXw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 19:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbYGCXwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 19:52:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188AbYGCXwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 19:52:18 -0400
Date: Thu, 3 Jul 2008 19:51:59 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/2] Avoid bio_endio recursion
In-Reply-To: <20080704000010.08db5daf@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.64.0807031946580.21723@engineering.redhat.com>
References: <Pine.LNX.4.64.0806240118250.24220@engineering.redhat.com>
 <20080624080744.GL20851@kernel.dk> <Pine.LNX.4.64.0806241017390.23052@engineering.redhat.com>
 <20080625082421.GU20851@kernel.dk> <Pine.LNX.4.64.0806252008380.11130@engineering.redhat.com>
 <20080626070723.GL20851@kernel.dk> <Pine.LNX.4.64.0807020001290.9097@engineering.redhat.com>
 <20080702082511.GF20055@kernel.dk> <Pine.LNX.4.64.0807031704120.20244@engineering.redhat.com>
 <20080703220449.20688451@lxorguk.ukuu.org.uk>
 <Pine.LNX.4.64.0807031843480.10463@engineering.redhat.com>
 <20080704000010.08db5daf@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jul 2008, Alan Cox wrote:

>> SCSI. Even the NCQ commands are done via IDE registers, not SCSI command
>> block. It seems like someone wanted to save few weeks of coding by reusing
>
> Thats really a trivial question of encoding, in all but actual
> byte encoding it is SCSI. Once you look at SAS and ATAPI it's all the
> more clear.

For SAS and ATAPI you're right - that's SCSI.

But not for SATA disks. The only thing SCSI and SATA disk have common is 
that they may process concurrently more requests. There's nothing else.

Mikulas
