Return-Path: <linux-kernel-owner+w=401wt.eu-S1759230AbYESXGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230AbYESXGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 19:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754833AbYESXF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 19:05:57 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:38092 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756042AbYESXF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 19:05:57 -0400
Date: Mon, 19 May 2008 19:05:11 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6.26-rc2-mm1] sync to speed up?
Message-ID: <20080519230511.GL15035@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Dave Young <hidave.darkstar@gmail.com>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <a8e1da0805190015t2044c33ar4b7320d0a37d7e09@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0805190015t2044c33ar4b7320d0a37d7e09@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 03:15:09PM +0800, Dave Young wrote:
> Hi,
> 
> With 2.6.26-rc2-mm1 I need to sync frequently. It's not normal as my
> understanding.
> 
> 1. scp a big file from a lan server. Firstly the speed is about 8M/s,
> but the speed will slow down to 100K/s at last. After I exec "sync",
> the speed will restore.
> 
> Is this a known issue?

Dave, what filesystem are you using?  Jiri's patch on this thread was
to fix a problem in ext4, which means that's fixing a problem which is
unrelated to the slow mkfs.ext2 problem (which is writing to a block
device, not a file in a ext4 filesystem), and so it's likely unrelated
to your problem (unless you're using ext4 and didn't tell us :-).

Andrew's probably right that it may be related to the slow mkfs
problem.  Can you confirm that you are seeing this on 2.6.26-rc2-mm1,
but not on stock 2.6.26.rc2?

       	       	       	      	      	    - Ted
