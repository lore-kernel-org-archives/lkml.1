Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbXDUAnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbXDUAnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 20:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbXDUAnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 20:43:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926AbXDUAns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 20:43:48 -0400
Message-ID: <46295E3B.2070503@redhat.com>
Date: Fri, 20 Apr 2007 19:43:39 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (Macintosh/20070221)
MIME-Version: 1.0
To: cmm@us.ibm.com
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ext4 development <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] fix ext2 allocator overflows above 31 bit blocks
References: <4628F3ED.9040101@redhat.com>	 <20070420230208.GU5967@schatzie.adilger.int>  <46294967.6070601@redhat.com> <1177115236.3778.23.camel@dyn9047017103.beaverton.ibm.com>
In-Reply-To: <1177115236.3778.23.camel@dyn9047017103.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mingming Cao wrote:
> On Fri, 2007-04-20 at 18:14 -0500, Eric Sandeen wrote:
>> It's a bug, today.   
> 
> They are fixed in mm tree, as part of the patches which backports ext3
> block reservation code to ext2. filesystem block numbers are all
> ext2_fsblk_t type(i.e. unsigned long)(see ext2_new_blocks()). Maybe need
> a round of thorough review to see if anything left, but I think what in
> mm tree looks good.

Oh... oops.  I didn't think to check mm, didn't expect to find those 
changes on ext2.  Ok, I will double-check that against what I did.

> And those patches in mm tree also backports the ext3 best-effort
> allocates multiple blocks code (allocate multiple blocks within the
> block reservation window as much as possible), FYI.

Ok, thanks Mingming!

-Eric
