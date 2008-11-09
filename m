Return-Path: <linux-kernel-owner+w=401wt.eu-S1756896AbYKIWuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896AbYKIWuu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 17:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756298AbYKIWum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 17:50:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:33628 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756267AbYKIWul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 17:50:41 -0500
Date: Sun, 9 Nov 2008 22:50:38 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.36.9
Message-ID: <20081109225038.GA31096@hera.kernel.org>
Reply-To: w@1wt.eu
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 09 Nov 2008 22:50:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've just released Linux 2.4.36.9.

This version contains several fixes which are worth upgrading.
One of them fixes a possible local DoS using AF_UNIX sockets. The
other ones are less serious, and most of them are backports from
2.6-stable.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/patch-2.4.36.9.bz2
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.36.9

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.4.36.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.4.36.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.4.36.y.git

Regards,
Willy

---
Summary of changes from v2.4.36.8 to v2.4.36.9
============================================

Andy Gospodarek (1):
      bonding: fix panic when taking bond interface down before removing module

Ayaz Abdulla (1):
      forcedeth: fix checksum flag

David Miller (1):
      net: Fix recursive descent in __scm_destroy().

Eric Sandeen (1):
      ext: Avoid printk floods in the face of directory

Eric Sesterhenn (1):
      hfsplus: fix Buffer overflow with a corrupted image

Ilpo Järvinen (1):
      netfilter: snmp nat leaks memory in case of failure

Jean Delvare (2):
      i2c: The i2c mailing list is moving
      i2c: Update comment of I2C_FUNC_SMBUS_*_I2C_BLOCK

Marcel Sebek (1):
      backport vlan device unregister fix

Willy Tarreau (1):
      Change VERSION to 2.4.36.9

