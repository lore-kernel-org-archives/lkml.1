Return-Path: <linux-kernel-owner+w=401wt.eu-S1753694AbYJUCIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbYJUCIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 22:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbYJUCIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 22:08:36 -0400
Received: from cnmailgate04.alcatel-sbell.com.cn ([211.144.215.47]:38468 "EHLO
	cnshjsmin03.cn.alcatel-lucent.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750998AbYJUCIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 22:08:35 -0400
X-AuditID: ac189297-a9f7fbb000000fe5-05-48fd3972e353
Message-ID: <48FD3986.6040909@alcatel-lucent.com>
Date: Tue, 21 Oct 2008 10:08:06 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: pls help me: ext3 filesystem reported errors while deleting files
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Oct 2008 02:07:52.0537 (UTC) FILETIME=[D3197C90:01C93321]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

After I uncompressed a big tar file (about 600MB) that has been mounted 
through NFS to local
hard disk, I tried to delete all of files from the tar file, but ext3 
filesystem reported huge errors
as follows. Note that I'm using IDE driver instead of ATA driver for 
hard disk.

SP(27-A) $ cd /disk_root/
SP(27-A) $ busybox tar -zxf /aaa/Gavin/sp3m/target_7xx_cge5.2008-07-10.tgz
SP(27-A) $ ls
bin         home        media       root        sys
boot        lib         mnt         sbin        tmp
dev         lost+found  opt         selinux     usr
etc         man         proc        srv         var
SP(27-A) $ rm -fr *
EXT3-fs error (device hdc5): ext3_free_blocks_sb: bit already cleared 
for block 538640
EXT3-fs error (device hdc5): ext3_free_blocks_sb: bit already cleared 
for block 538648
EXT3-fs error (device hdc5): ext3_free_blocks_sb: bit already cleared 
for block 538648
EXT3-fs error (device hdc5): ext3_free_blocks_sb: bit already cleared 
for block 534539
EXT3-fs error (device hdc5): ext3_free_blocks_sb: bit already cleared 
for block 534540
:
:

Thanks,
Gavin
