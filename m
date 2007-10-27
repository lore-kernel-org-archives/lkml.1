Return-Path: <linux-kernel-owner+w=401wt.eu-S1757130AbXJ0R6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130AbXJ0R6X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 13:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbXJ0R6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 13:58:15 -0400
Received: from aun.it.uu.se ([130.238.12.36]:59851 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbXJ0R6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 13:58:14 -0400
Date: Sat, 27 Oct 2007 19:57:38 +0200 (MEST)
Message-Id: <200710271757.l9RHvcY9021751@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: paulus@samba.org
Subject: 2.6.24-rc1 sysctl table check failed on PowerMac
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Booting 2.6.24-rc1 on my PowerMac the kernel now spits
out a sysctl warning early in the boot sequence:

--- dmesg-2.6.23
+++ dmesg-2.6.24-rc1
...
 IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
 TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
 TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
 TCP: Hash tables configured (established 131072 bind 65536)
 TCP reno registered
+sysctl table check failed: /kernel .1 Writable sysctl directory
 io scheduler noop registered
 io scheduler anticipatory registered (default)
 io scheduler deadline registered
