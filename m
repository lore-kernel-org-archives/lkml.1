Return-Path: <linux-kernel-owner+w=401wt.eu-S1753267AbZEIMiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbZEIMiz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 08:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbZEIMiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 08:38:46 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:40190 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbZEIMip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 08:38:45 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A057951.8040501@s5r6.in-berlin.de>
Date: Sat, 09 May 2009 14:38:41 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090411 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Jeff Mahoney <jeffm@suse.com>
CC: reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: 2.6.30-rc: reiserfs_delete_xattrs log spam (bug 13122)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just switched from 2.6.29.1 to 2.6.30-rc5, and I'm getting the same as 
the reporter of http://bugzilla.kernel.org/show_bug.cgi?id=13122 alias
http://marc.info/?l=linux-kernel&m=123990989515105, i.e. repetitions of
 >>>
May  9 14:27:22 stein REISERFS warning (device sda1): jdm-20004 
reiserfs_delete_xattrs: Couldn't delete all xattrs (-13)
May  9 14:27:22 stein
<<<

This happens in irregular intervals, but a lot of times --- presumably 
when certain files are accessed.  I'm on a recently set-up Gentoo 
machine.  I created its root filesystem using the Gentoo x86-64 minimal 
boot CD; my guess is that the kernel of the boot CD had 
CONFIG_REISERFS_FS_XATTR enabled.  All kernels which I used since then 
have it disabled:  2.6.27-gentoo-r8, 2.6.29.1, now 2.6.30-rc5.
-- 
Stefan Richter
-=====-=-=== -=-= -==-=
http://arcgraph.de/sr/
