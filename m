Return-Path: <linux-kernel-owner+w=401wt.eu-S1757630AbYFIFeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630AbYFIFeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 01:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbYFIFd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 01:33:59 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58349 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbYFIFd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 01:33:58 -0400
Message-ID: <484CC071.4080007@np.css.fujitsu.com>
Date: Mon, 09 Jun 2008 14:32:33 +0900
From: Kentaro Makita <k-makita@np.css.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@ZenIV.linux.org.uk, harvey.harrison@gmail.com
Subject: [PATCH -mm 0/2] vfs: __shrink_dcache_sb() fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I fix my patch based on Dave Chinner's comments as follows:
 http://lkml.org/lkml/2008/5/22/469

This fix contains following two patches.

 - fix coding style. (patch 1/2)
 - add cond_resched_lock() in scanning LRU. (patch 2/2)

These patches depend on following patches on -mmotm tree, and tested on -rc5:
http://userweb.kernel.org/~akpm/mmotm/broken-out/fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries.patch
http://userweb.kernel.org/~akpm/mmotm/broken-out/fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix.patch

Best Regards,
Kentaro Makita

