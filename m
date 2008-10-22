Return-Path: <linux-kernel-owner+w=401wt.eu-S1759346AbYJVUyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346AbYJVUyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 16:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbYJVUxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 16:53:34 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:38073 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184AbYJVUxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 16:53:34 -0400
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
Date: Wed, 22 Oct 2008 22:53:19 +0200
Message-Id: <1224708801-16675-1-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: c2port (Version 3): support for Silicon C2 Interface.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

C2 port implements a two wire serial communication protocol (bit
banging) designed to enable in-system programming, debugging, and
boundary-scan testing on low pin-count Silicon Labs devices.

Main references are at Silicon Laboratories site:

* AN127: FLASH Programming via the C2 Interface
     http://www.silabs.com/public/documents/tpub_doc/anote/Microcontrollers/Small_Form_Factor/en/an127.pdf

* C2 Specification
     http://www.silabs.com/public/documents/tpub_doc/spec/Microcontrollers/en/C2spec.pdf

Currently this code supports only flash programming through sysfs
interface but extensions shoud be easy to add.

Changelog
=========

Version 2 -> 3:
---------------

* Static variables fix up.

* Update_lock is now initialised at compile-time, not at runtime.

* Memory leak in c2port_device_register fixed.

* Comments review.

Version 1 -> 2:
---------------

* Documentation added.

* One client added.


Rodolfo

--

 b/Documentation/ABI/testing/sysfs-c2port   |   88 ++
 b/Documentation/c2port.txt                 |   90 ++
 b/drivers/misc/Kconfig                     |    2 
 b/drivers/misc/Makefile                    |    1 
 b/drivers/misc/c2port/Kconfig              |   24 
 b/drivers/misc/c2port/Makefile             |    1 
 b/drivers/misc/c2port/c2port-duramar2150.c |  158 ++++
 b/drivers/misc/c2port/core.c               | 1002 +++++++++++++++++++++++++++++
 b/include/linux/c2port.h                   |   65 +
 drivers/misc/c2port/Kconfig                |   11 
 drivers/misc/c2port/Makefile               |    2 
 11 files changed, 1444 insertions(+)


