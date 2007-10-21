Return-Path: <linux-kernel-owner+w=401wt.eu-S1753664AbXJUTXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbXJUTXh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 15:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbXJUTXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 15:23:30 -0400
Received: from www17.your-server.de ([213.133.104.17]:43188 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbXJUTXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 15:23:30 -0400
Message-ID: <471BA729.6050206@m3y3r.de>
Date: Sun, 21 Oct 2007 21:23:21 +0200
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Device mapper regression 2.6.23 vs. v2.6.23-6597-gcfa76f0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I have an external hard drive with an encrypted partition. I am using
kde so all i had to do under 2.6.23 was
  "cryptsetup luksOpen /dev/sdb2 crypt-extern"

then udev/hal/kde (?)automatically created an desktop icon. i could
click this icon to mount and open the drive.

when i do the luksOpen command with v2.6.23-6597-gcfa76f0 this icon is
not created anymore.

a few commits were made in drivers/md, so it seems something broke.

config extract:

CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
CONFIG_DM_ZERO=m
# CONFIG_DM_MULTIPATH is not set
CONFIG_DM_DELAY=m
CONFIG_DM_UEVENT=y
# CONFIG_FUSION is not set

any ideas?

mfg
thomas
