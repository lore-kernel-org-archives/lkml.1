Return-Path: <linux-kernel-owner+w=401wt.eu-S1753799AbZH3Plr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799AbZH3Plr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 11:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbZH3Plq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 11:41:46 -0400
Received: from thunk.org ([69.25.196.29]:43268 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410AbZH3Plp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 11:41:45 -0400
Date: Sun, 30 Aug 2009 11:41:44 -0400
From: Theodore Tso <tytso@mit.edu>
To: Ed Tomlinson <edt@aei.ca>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: Ext4 corruption that will not go away
Message-ID: <20090830154144.GC23828@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Ed Tomlinson <edt@aei.ca>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
References: <E1LOG9D-0006h4-7R@closure.thunk.org> <20090119113300.GC9482@skywalker> <200908300025.48034.edt@aei.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908300025.48034.edt@aei.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 30, 2009 at 12:25:47AM -0400, Ed Tomlinson wrote:
> Hi,
> 
> I am running 2.6.31-rc8+ and have ext4 corruption that will not go away.
> 
> My root fs is ext4 on sdb3.  I have moved the directory with corruption into lost+found and booted to a rescuse
> system (arch linux) and run fsck.ext4 on the filesystem, which then reports its clean...  Booting back into my
> gentoo system and attempting to remove the xx directory from lost+found gives:
> 
> [  172.408799] EXT4-fs error (device sdb3): ext4_ext_check_inode: bad header/extent in inode #706801: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)

Can you send in the output of running fsck.ext4 on the filesystem, please?

    	     	    	      	      - Ted
