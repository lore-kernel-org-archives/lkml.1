Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212Ab0A0O0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab0A0O0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 09:26:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755088Ab0A0O0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 09:26:21 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:45085 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045Ab0A0O0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 09:26:21 -0500
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3][linux-next] ramzswap: bug fixes and some cleanups
Date: Wed, 27 Jan 2010 19:54:03 +0530
Message-Id: <1264602246-12880-1-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ramzswap driver creates virtual block devices which
can be used (only) as swap disks. Pages swapped to these
disks are compressed and stored in memory itself.
Project home: http://code.google.com/p/compcache/

These patches apply to linux-next.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>

Nitin Gupta (3):
  use lock for 64-bit stats
  flush block device before reset
  set block size to PAGE_SIZE and some cleanups

 drivers/staging/ramzswap/ramzswap_drv.c   |  144 ++++++++++++++++------------
 drivers/staging/ramzswap/ramzswap_drv.h   |   61 ++++++++++--
 drivers/staging/ramzswap/ramzswap_ioctl.h |    3 +-
 drivers/staging/ramzswap/xvmalloc.c       |    2 +-
 drivers/staging/ramzswap/xvmalloc.h       |    2 +-
 drivers/staging/ramzswap/xvmalloc_int.h   |    2 +-
 6 files changed, 137 insertions(+), 77 deletions(-)

