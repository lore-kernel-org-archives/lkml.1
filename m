Return-Path: <linux-kernel-owner+w=401wt.eu-S1763318AbXFEGt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763318AbXFEGt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 02:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757482AbXFEGtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 02:49:22 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:22587 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760684AbXFEGtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 02:49:21 -0400
Message-ID: <4665075F.1050903@sw.ru>
Date: Tue, 05 Jun 2007 10:49:03 +0400
From: Vasily Averin <vvs@sw.ru>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, devel@openvz.org,
       linux-ext4@vger.kernel.org, Stephen Tweedie <sct@redhat.com>,
       adilger@clusterfs.com
Subject: Re: [PATCH ext3/ext4] orphan list check on destroy_inode
References: <4663A0BF.9010008@sw.ru> <4664D2C6.4040804@redhat.com>
In-Reply-To: <4664D2C6.4040804@redhat.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:
> Vasily Averin wrote:
>> Customers claims to ext3-related errors, investigation showed that ext3
>> orphan list has been corrupted and have the reference to non-ext3 inode.
>> The following debug helps to understand the reasons of this issue.
> 
> Vasily, does your customer have this patch in place?
> 
> http://www.mail-archive.com/linux-ext4@vger.kernel.org/msg00889.html
> 
> If not, perhaps it could be leading to the same error, because the inode will
> not be properly removed from the orphan inode list when it is freed, and
> could then be recycled...

We did have a several bugreports occurred on the kernels without your patch, but
latest incident (when check in ext3_destroy_inode has been triggered) has been
occurred on the kernel where your patch has been applied.

Thank you,
	Vasily Averin
