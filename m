Return-Path: <linux-kernel-owner+w=401wt.eu-S1754108AbXEaBMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbXEaBMD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 21:12:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbXEaBLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 21:11:50 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:33166 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751289AbXEaBLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 21:11:49 -0400
Date: Thu, 31 May 2007 11:11:27 +1000
From: David Chinner <dgc@sgi.com>
To: device-mapper development <dm-devel@redhat.com>,
       David Chinner <dgc@sgi.com>, Tejun Heo <htejun@gmail.com>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org,
       Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [dm-devel] Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
Message-ID: <20070531011127.GO86004887@sgi.com>
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070528024559.GA85884050@sgi.com> <18010.17713.76863.245176@notabene.brown> <20070528042926.GC85884050@sgi.com> <18014.6860.989819.665778@notabene.brown> <20070531010739.GR25091@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531010739.GR25091@agk.fab.redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 02:07:39AM +0100, Alasdair G Kergon wrote:
> On Thu, May 31, 2007 at 10:46:04AM +1000, Neil Brown wrote:
> > If a filesystem cares, it could 'ask' as suggested above.
> > What would be a good interface for asking?
> 
> XFS already tests:
>   bd_disk->queue->ordered == QUEUE_ORDERED_NONE

The side effects of removing that check is what started
this whole discussion.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
