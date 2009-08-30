Return-Path: <linux-kernel-owner+w=401wt.eu-S1751647AbZH3Ecb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbZH3Ecb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 00:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362AbZH3Eca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 00:32:30 -0400
Received: from mail001.aei.ca ([206.123.6.130]:52739 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbZH3Ec3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 00:32:29 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Aug 2009 00:32:29 EDT
From: Ed Tomlinson <edt@aei.ca>
To: linux-kernel@vger.kernel.org
Subject: Ext4 corruption that will not go away
Date: Sun, 30 Aug 2009 00:25:47 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc8-crc; KDE/4.2.4; x86_64; ; )
Cc: linux-ext4@vger.kernel.org
References: <E1LOG9D-0006h4-7R@closure.thunk.org> <20090119113300.GC9482@skywalker>
In-Reply-To: <20090119113300.GC9482@skywalker>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908300025.48034.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am running 2.6.31-rc8+ and have ext4 corruption that will not go away.

My root fs is ext4 on sdb3.  I have moved the directory with corruption into lost+found and booted to a rescuse
system (arch linux) and run fsck.ext4 on the filesystem, which then reports its clean...  Booting back into my
gentoo system and attempting to remove the xx directory from lost+found gives:

[  172.408799] EXT4-fs error (device sdb3): ext4_ext_check_inode: bad header/extent in inode #706801: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)                                                                                                
[  172.429410] EXT4-fs error (device sdb3): ext4_ext_check_inode: bad header/extent in inode #706801: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)                                                                                                
[  172.449920] EXT4-fs error (device sdb3): ext4_ext_check_inode: bad header/extent in inode #706801: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)

The above is repeatable.

How can I _really_ clean this fs?  What info is needed to help the process?

TIA,
Ed Tomlinson

