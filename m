Return-Path: <linux-kernel-owner+w=401wt.eu-S1756599AbXKUVH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599AbXKUVH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 16:07:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbXKUVHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 16:07:50 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:42207 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751616AbXKUVHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 16:07:50 -0500
Date: Wed, 21 Nov 2007 16:07:49 -0500
To: alex-lists-linux-kernel@yuriev.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Identifying a specific affected file on Ext3 on a top of raid0 of raid1s
Message-ID: <20071121210749.GC1299@csclub.uwaterloo.ca>
References: <20071121205753.GA26864@s1.yuriev.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071121205753.GA26864@s1.yuriev.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2007 at 03:57:53PM -0500, alex-lists-linux-kernel@yuriev.com wrote:
> I have a rather nasty situation developing on one of the big 24x7 
> production database servers. It seems that a batch of drives in one of the
> servers started to fail. 
> 
> The file servers are ext3fs on a top of raid-0 over a pair of raid-1 mirrors, 
> with each of raid-1 mirrors having two drives. The issue is that all four 
> drives are developing errors. 
> 
> Is there a way to determine what files are affected if I know the LBA# of the
> errors on individual drives?
> 
> It is running under 2.6.20.x series of kernels.

Most likely debugfs can tell you what filesystem block is used by a file
and which file is using a given filesystem block, although you would
still have to translate the disk block number through the raid layers
and partitions to find where it is relative to the begining of the
partition the filesystem is on.

--
Len Sorensen
