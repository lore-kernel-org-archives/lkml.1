Return-Path: <linux-kernel-owner+w=401wt.eu-S1755279AbZDEMsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbZDEMsb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 08:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbZDEMsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 08:48:22 -0400
Received: from col0-omc1-s2.col0.hotmail.com ([65.55.34.12]:19176 "EHLO
	col0-omc1-s2.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751717AbZDEMsV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 08:48:21 -0400
Message-ID: <COL116-W68F0521CACD2E1656E8D1BDA870@phx.gbl>
X-Originating-IP: [84.216.37.216]
From: Peter Hallberg <hallberg68@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: Intepreting an oops
Date: Sun, 5 Apr 2009 14:48:19 +0200
Importance: Normal
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 05 Apr 2009 12:48:19.0964 (UTC) FILETIME=[CC3403C0:01C9B5EC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


How does one translate the offset in the function to a line number in the source code?
[  218.418473] Call Trace:
[  218.418484]  [] :nnpfs:nnpfs_writepage+0xab/0x230
[  218.418498]  [] __writepage+0xa/0x30
[  218.418503]  [] write_cache_pages+0x250/0x340
[  218.418509]  [] __writepage+0x0/0x30
[  218.418522]  [] generic_file_aio_write+0x6f/0xd0
[  218.418540]  [] do_writepages+0x2b/0x40
[  218.418545]  [] __filemap_fdatawrite_range+0x52/0x60
[  218.418558]  [] filemap_write_and_wait+0x35/0x50
[  218.418570]  [] :nnpfs:nnpfs_fsync_int+0x47/0x1b0
[  218.418599]  [] :nnpfs:nnpfs_release_file+0x9d/0xc0
[  218.418608]  [] filp_close+0x33/0x90
[  218.418615]  [] sys_close+0x9f/0x100
[  218.418622]  [] system_call+0x7e/0x83


_________________________________________________________________
Hitta kärleken nu i vår!
http://dejting.se.msn.com/channel/index.aspx?trackingid=1002952