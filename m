Return-Path: <linux-kernel-owner+w=401wt.eu-S1423393AbXDYWrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423393AbXDYWrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 18:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423392AbXDYWrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 18:47:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:23349 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422881AbXDYWrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 18:47:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,452,1170662400"; 
   d="scan'208";a="79225067"
Date: Wed, 25 Apr 2007 15:47:10 -0700
From: Valerie Henson <val_henson@linux.intel.com>
To: Nikita Danilov <nikita@clusterfs.com>
Cc: David Lang <david.lang@digitalinsight.com>, Amit Gud <gud@cis.ksu.edu>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       riel@surriel.com, zab@zabbo.net, arjan@infradead.org,
       suparna@in.ibm.com, brandon@ifup.org, karunasagark@gmail.com,
       gud@ksu.edu
Subject: Re: [RFC][PATCH] ChunkFS: fs fission for faster fsck
Message-ID: <20070425224710.GB16129@nifty>
References: <Pine.LNX.4.64.0704230544450.1682@camaro.cis.ksu.edu> <17965.60841.900376.524639@gargle.gargle.HOWL> <Pine.LNX.4.63.0704241123200.7701@qynat.qvtvafvgr.pbz> <17966.23512.363955.141489@gargle.gargle.HOWL> <Pine.LNX.4.63.0704241222110.7701@qynat.qvtvafvgr.pbz> <17967.15531.450627.972572@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17967.15531.450627.972572@gargle.gargle.HOWL>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 03:34:03PM +0400, Nikita Danilov wrote:
> 
> What is more important, design puts (as far as I can see) no upper limit
> on the number of continuation inodes, and hence, even if _average_ fsck
> time is greatly reduced, occasionally it can take more time than ext2 of
> the same size. This is clearly unacceptable in many situations (HA,
> etc.).

Actually, there is an upper limit on the number of continuation
inodes.  Each file can have a maximum of one continuation inode per
chunk. (This is why we need to support sparse files.)

-VAL
