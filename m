Return-Path: <linux-kernel-owner+w=401wt.eu-S1752096AbXFTUuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbXFTUuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 16:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbXFTUuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 16:50:09 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:36350 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbXFTUuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 16:50:07 -0400
Date: Wed, 20 Jun 2007 14:50:02 -0600
From: Andreas Dilger <adilger@clusterfs.com>
To: clameter@sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [34/37] Large blocksize support in ramfs
Message-ID: <20070620205002.GH5181@schatzie.adilger.int>
Mail-Followup-To: clameter@sgi.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Mel Gorman <mel@skynet.ie>,
	William Lee Irwin III <wli@holomorphy.com>,
	David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
	Badari Pulavarty <pbadari@gmail.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>
References: <20070620182907.506775016@sgi.com> <20070620183013.967063205@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070620183013.967063205@sgi.com>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 20, 2007  11:29 -0700, clameter@sgi.com wrote:
> If you apply this patch and then you can f.e. try this:
> 
> 	mount -tramfs -o10 none /media

> @@ -164,10 +165,15 @@ static int ramfs_fill_super(struct super
> +	if (options && *options)
> +		order = simple_strtoul(options, NULL, 10);

This is probably a bad name for a mount option.  What about "order=10"?
Otherwise you prevent any other option from being used in the future.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

