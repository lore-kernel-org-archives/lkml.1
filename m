Return-Path: <linux-kernel-owner+w=401wt.eu-S1763549AbYBVUv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763549AbYBVUv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 15:51:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755530AbYBVUvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 15:51:19 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:39060 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388AbYBVUvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 15:51:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=tmSAoJipSbKJABPEaUXzzrD+MkZmEOJ6JBb0x2HAy1yrS+oQpqYhvlA/8I6arHRTuZ+ymzkfpI4jmYozXaIQ5DMaTis1HVE1f/an0vsz7ZKrxja0UGeWkl+RjMJKsRfZoR+KgVsU+ybwwIQbMN6NbqzScvV9EOc9wBVIBgOeTgo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: remove ide-tape documentation from Documentation/ide.txt
Date: Fri, 22 Feb 2008 22:05:32 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802222205.32903.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More complete documentation is available in Documentation/ide/ide-tape.txt.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 Documentation/ide.txt |   47 -----------------------------------------------
 1 file changed, 47 deletions(-)

Index: b/Documentation/ide.txt
===================================================================
--- a/Documentation/ide.txt
+++ b/Documentation/ide.txt
@@ -279,53 +279,6 @@ You also need to use "probe" kernel para
 
 ================================================================================
 
-IDE ATAPI streaming tape driver
--------------------------------
-
-This driver is a part of the Linux ide driver and works in co-operation
-with linux/drivers/block/ide.c.
-
-The driver, in co-operation with ide.c, basically traverses the
-request-list for the block device interface. The character device
-interface, on the other hand, creates new requests, adds them
-to the request-list of the block device, and waits for their completion.
-
-Pipelined operation mode is now supported on both reads and writes.
-
-The block device major and minor numbers are determined from the
-tape's relative position in the ide interfaces, as explained in ide.c.
-
-The character device interface consists of the following devices:
-
- ht0		major 37, minor 0	first  IDE tape, rewind on close.
- ht1		major 37, minor 1	second IDE tape, rewind on close.
- ...
- nht0		major 37, minor 128	first  IDE tape, no rewind on close.
- nht1		major 37, minor 129	second IDE tape, no rewind on close.
- ...
-
-Run /dev/MAKEDEV to create the above entries.
-
-The general magnetic tape commands compatible interface, as defined by
-include/linux/mtio.h, is accessible through the character device.
-
-General ide driver configuration options, such as the interrupt-unmask
-flag, can be configured by issuing an ioctl to the block device interface,
-as any other ide device.
-
-Our own ide-tape ioctl's can be issued to either the block device or
-the character device interface.
-
-Maximal throughput with minimal bus load will usually be achieved in the
-following scenario:
-
-	1.	ide-tape is operating in the pipelined operation mode.
-	2.	No buffering is performed by the user backup program.
-
-
-
-================================================================================
-
 Some Terminology
 ----------------
 IDE = Integrated Drive Electronics, meaning that each drive has a built-in
