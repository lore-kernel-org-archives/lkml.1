Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab0BUPc2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 10:32:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:57044 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188Ab0BUPc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 10:32:27 -0500
Subject: How to disable configfs_example modules
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Randy Dunlap <randy.dunlap@oracle.com>,
       Joel Becker <joel.becker@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 21 Feb 2010 20:48:04 +0530
Message-Id: <1266765484.2192.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Randy,

I am trying to build no modules but unfortunately I am getting 3 modules
with http://userweb.kernel.org/~jaswinder/Corei7/config-i7-64.txt :

  INSTALL Documentation/filesystems/configfs/configfs_example_explicit.ko
  INSTALL Documentation/filesystems/configfs/configfs_example_macros.ko
  INSTALL drivers/scsi/scsi_wait_scan.ko

How can I get rid of configfs_example modules.

What is the magic in 'ifneq ($(CONFIG_CONFIGFS_FS),)' :

Documentation/filesystems/configfs/Makefile :
ifneq ($(CONFIG_CONFIGFS_FS),)
obj-m += configfs_example_explicit.o configfs_example_macros.o
endif

Thanks,
--
Jaswinder Singh.

