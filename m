Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbYGWR6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbYGWR6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 13:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbYGWR6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 13:58:40 -0400
Received: from www17.your-server.de ([213.133.104.17]:57246 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbYGWR6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 13:58:39 -0400
Subject: next-20080723: build fails for dm-snapshot.ko
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       mpatocka@redhat.com
Content-Type: text/plain
Date: Wed, 23 Jul 2008 19:58:37 +0200
Message-Id: <1216835917.19707.3.camel@dhcppc2>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Building modules, stage 2.
Kernel: arch/x86/boot/bzImage is ready  (#24)
  MODPOST 1518 modules
ERROR: "__umoddi3" [drivers/md/dm-snapshot.ko] undefined!
WARNING: modpost: Found 6 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2


CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_RAID5_RESHAPE=y
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_BLK_DEV_DM=m
CONFIG_DM_DEBUG=y
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y


