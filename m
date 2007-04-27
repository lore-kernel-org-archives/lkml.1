Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbXD0POs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbXD0POs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 11:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755977AbXD0POr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 11:14:47 -0400
Received: from [198.99.130.12] ([198.99.130.12]:53035 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755960AbXD0POq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 11:14:46 -0400
Date: Fri, 27 Apr 2007 11:06:47 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Valerie Henson <val_henson@linux.intel.com>
Cc: Amit Gud <gud@ksu.edu>, Nikita Danilov <nikita@clusterfs.com>,
       David Lang <david.lang@digitalinsight.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       riel@surriel.com, zab@zabbo.net, arjan@infradead.org,
       suparna@in.ibm.com, brandon@ifup.org, karunasagark@gmail.com
Subject: Re: [RFC][PATCH] ChunkFS: fs fission for faster fsck
Message-ID: <20070427150647.GA6019@c2.user-mode-linux.org>
References: <17965.60841.900376.524639@gargle.gargle.HOWL> <Pine.LNX.4.63.0704241123200.7701@qynat.qvtvafvgr.pbz> <17966.23512.363955.141489@gargle.gargle.HOWL> <Pine.LNX.4.63.0704241222110.7701@qynat.qvtvafvgr.pbz> <17967.15531.450627.972572@gargle.gargle.HOWL> <20070425224710.GB16129@nifty> <20070426141455.GA6155@c2.user-mode-linux.org> <4630CAEC.2050909@ksu.edu> <20070426160504.GA7970@c2.user-mode-linux.org> <20070427045824.GB20286@nifty>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427045824.GB20286@nifty>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 09:58:25PM -0700, Valerie Henson wrote:
> Here's an example, spelled out:
> 
> Allocate file 1 in chunk A.
> Grow file 1.
> Chunk A fills up.
> Allocate continuation inode for file 1 in chunk B.
> Chunk A gets some free space.
> Chunk B fills up.
> Pick chunk A for allocating next block of file 1.
> Try to look up a continuation inode for file 1 in chunk A.
> Continuation inode for file 1 found in chunk A!
> Attach newly allocated block to existing inode for file 1 in chunk A.

So far, so good (and the slides are helpful, tx!).  What happens when
file 1 keeps growing and chunk A fills up (and chunk B is still full)?
Can the same continuation inode also point at chunk C, where the file
is going to grow to?

				Jeff

-- 
Work email - jdike at linux dot intel dot com
