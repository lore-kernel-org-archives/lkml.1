Return-Path: <linux-kernel-owner+w=401wt.eu-S1756404AbZKQW3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404AbZKQW3D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:29:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756392AbZKQW3C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:29:02 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:65379 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756387AbZKQW3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:29:01 -0500
Date: Tue, 17 Nov 2009 14:29:05 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: reiserfs-devel@vger.kernel.org
cc: LKML <linux-kernel@vger.kernel.org>
Subject: reiser4 for 2.6.33?
Message-ID: <alpine.DEB.2.01.0911171420480.27639@bogon.housecafe.de>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/LaZnMQ49tYpPl2AkiVD9AnI3k7jDqU26i8ND
 zXfxsrWINdWSR9Ij2eOVrBBOFD8IqBEJSN5LF21+RY2WOkkr+e
 uhdMnxUOQAQ68yqByqc6w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's autumn[0] already and even with 2.6.32 not quite ready yet, let me 
be the one asking the inevitable question:
 What are the plans for reiser4 being included in 2.6.33? The 
diffstat for the 2.6.31 patch looks rather promising, at least to me:

$ diffstat reiser4-for-2.6.31.patch | grep -v fs/reiser4
 Documentation/Changes                         |   12 
 Documentation/filesystems/reiser4.txt         |   75 
 fs/Kconfig                                    |    1 
 fs/Makefile                                   |    1 
 fs/fs-writeback.c                             |    5 
 include/linux/fs.h                            |    3 
 include/linux/mm.h                            |    1 
 mm/filemap.c                                  |    3 
 mm/page-writeback.c                           |   26 
 170 files changed, 77581 insertions(+), 1 deletion(-)

Or maybe it can find a place in -staging if there are still strong 
objections against a general inclusion?

Thanks,
Christian.

[0] http://marc.info/?l=reiserfs-devel&m=124904274311847&w=2
-- 
BOFH excuse #70:

nesting roaches shorted out the ether cable
