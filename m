Return-Path: <linux-kernel-owner+w=401wt.eu-S1763205AbXFRQ2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763205AbXFRQ2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 12:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759376AbXFRQ2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 12:28:12 -0400
Received: from mail4.kite.se ([212.214.165.225]:47225 "EHLO mail4.kite.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757980AbXFRQ2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 12:28:11 -0400
Message-ID: <4676B298.4080904@kite.se>
Date: Mon, 18 Jun 2007 18:28:08 +0200
From: Magnus Naeslund <mag@kite.se>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Magnus Naeslund <mag@kite.se>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       linux-kernel@vger.kernel.org
Subject: Re: ARC-1260: No space left on device, when there is (or should be)
 free space left
References: <4676679E.5040901@kite.se> <Pine.LNX.4.64.0706180730320.14972@localhost.localdomain> <4676787F.30609@kite.se> <20070618134413.GC30244@thunk.org>
In-Reply-To: <20070618134413.GC30244@thunk.org>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> 
> How are you using the filesystem?  This wouldn't happen to be one of
> the backup schemes that use hard links and huge numbers of
> directories, would it?  And how did you create the filesystem
> originally?  Normally mke2fs is quite generous with the number of
> inodes it creates to avoid this problem.  Did you use -T largefile or
> -T largefile4 by any chance?  Or did you manually specify a
> non-standard inode_ratio size?
> 

It's a filesystem containing images varying from 300kb to 2mb of size.
It currently contains 1426394 files in 4125 directories.

Magnus

I believe this has the appropriate information:
tune2fs 1.40-WIP (14-Nov-2006)
Filesystem volume name:   <none>
Last mounted on:          <not available>
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal resize_inode dir_index filetype needs_recovery sparse_super large_file
Filesystem flags:         signed directory hash
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              1430528
Block count:              1464843264
Reserved block count:     0
Free blocks:              998810993
Free inodes:              0
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      674
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         32
Inode blocks per group:   1
Filesystem created:       Sun Apr  1 12:46:39 2007
Last mount time:          Mon Jun 18 14:23:26 2007
Last write time:          Mon Jun 18 14:23:26 2007
Mount count:              8
Maximum mount count:      20
Last checked:             Sun Apr  1 12:46:39 2007
Check interval:           15552000 (6 months)
Next check after:         Fri Sep 28 12:46:39 2007
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               128
Journal inode:            8
Default directory hash:   tea
Directory Hash Seed:      f252b473-6db0-499b-8de1-c788e84563dc
Journal backup:           inode blocks


