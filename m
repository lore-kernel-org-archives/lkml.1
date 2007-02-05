Return-Path: <linux-kernel-owner+w=401wt.eu-S932096AbXBEL6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbXBEL6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 06:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932106AbXBEL6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 06:58:36 -0500
Received: from kruk.ds2.uw.edu.pl ([193.0.110.20]:2203 "EHLO mail.wijata.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932096AbXBEL6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 06:58:35 -0500
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Feb 2007 06:58:35 EST
Date: Mon, 5 Feb 2007 12:51:07 +0100 (CET)
From: Rafal Wijata <0203@wijata.com>
To: linux-kernel@vger.kernel.org
Subject: find_exported_dentry: npd != pd -> stale NFS file handle
Message-ID: <Pine.LNX.4.64.0702051249200.25174@kruk.wijata.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please place me in CC when replying

I wonder if there's anybody that can help me. Sorry if posting to wrong 
group.

I have RH machines setup in LAN, each is NFS server and client.
All are SMP with sata HDDs
Some about server which hit the problem most of time
http://www.intel.com/design/servers/boards/s5000PSL/index.htm
2 * Intel(R) Xeon(R) CPU            5160  @ 3.00GHz
16GB ram
2.6.9-42.0.3.ELsmp #1 SMP Mon Sep 25 17:28:02 EDT 2006 i686 i686 i386 GNU/Linux
exported via nfs is separate filesystem (exporting mountpoint)
ext3 filesystem placed on raid0 array with 6 partitions on different 
drives

The following happens 
nfs server logs
find_exported_dentry: npd != pd

client gets stale nfs file handle and logs
NFS: Buggy server - nlink == 0!
nfs_fhget: iget failed


listing on client side shows broken (sym)links for a while, and then all 
is back fine.

I don't know how to solve it. Any help appreciated.

Rafal Wijata

