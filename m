Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbXDWVM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbXDWVM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 17:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbXDWVM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 17:12:59 -0400
Received: from smtp2.cc.ksu.edu ([129.130.7.16]:44656 "EHLO smtp2.cc.ksu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbXDWVM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 17:12:58 -0400
Message-ID: <462CCFD8.2040907@ksu.edu>
Date: Mon, 23 Apr 2007 10:25:12 -0500
From: Amit Gud <gud@ksu.edu>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: suparna@in.ibm.com
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       val_henson@linux.intel.com, riel@surriel.com, zab@zabbo.net,
       arjan@infradead.org, brandon@ifup.org, karunasagark@gmail.com
Subject: Re: [RFC][PATCH] ChunkFS: fs fission for faster fsck
References: <Pine.LNX.4.64.0704230544450.1682@camaro.cis.ksu.edu> <20070423162849.GB14113@in.ibm.com>
In-Reply-To: <20070423162849.GB14113@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Suparna Bhattacharya wrote:
> Could you send this out as a patch to ext2 codebase, so we can just look
> at the changes for chunkfs ? That might also make it small enough
> to inline your patch in email for review. 
> 
> What kind of results are you planning to gather to evaluate/optimize this ?
> 

Mainly I'm trying to gather following:

- Graph of continuation inodes vs. the file system fragmentation (or 
aging) factor with varying configurations of chunk sizes

- Graph of wall clock time vs. disk size + data on the disk with both 
chunkfs and native ext2, and/or other file systems


AG
-- 
May the source be with you.
http://www.cis.ksu.edu/~gud

