Return-Path: <linux-kernel-owner+w=401wt.eu-S1757959AbYFXBrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959AbYFXBrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 21:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757258AbYFXBqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 21:46:09 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53260 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935AbYFXBqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 21:46:04 -0400
Message-ID: <486051A2.6040805@np.css.fujitsu.com>
Date: Tue, 24 Jun 2008 10:45:06 +0900
From: Kentaro Makita <k-makita@np.css.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@ZenIV.linux.org.uk, harvey.harrison@gmail.com
Subject: [RESEND][PATCH -mm 0/2] vfs: __shrink_dcache_sb() fixes
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





