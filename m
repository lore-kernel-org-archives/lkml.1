Return-Path: <linux-kernel-owner+w=401wt.eu-S1761434AbYCAJCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761434AbYCAJCl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 04:02:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756775AbYCAI70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 03:59:26 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:13216 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248AbYCAI7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 03:59:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=PncNDGH0MQvlX9Xxmjc3tycWdDxueQAZ2G4ttYpd6ElbJr8cWLjsWtiTKWNkQ1VEY1LTDyIcK6wJz+r0S555csO6nCxCK57DUWo5cMSasIJ0W6BRcA4Hcc7DGzIhte4ZozWWS6ttHg8Xlv86FeCAEhXtHlFBxrOnyqY5Cyo6Hsk=
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 24/24] ide-tape: remove comments markup from Documentation/ide/ide-tape.txt
Date: Sat,  1 Mar 2008 09:58:48 +0100
Message-Id: <1204361928-30229-25-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
References: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 Documentation/ide/ide-tape.txt |  132 ++++++++++++++++++++--------------------
 1 files changed, 65 insertions(+), 67 deletions(-)

diff --git a/Documentation/ide/ide-tape.txt b/Documentation/ide/ide-tape.txt
index 51f596b..3f348a0 100644
--- a/Documentation/ide/ide-tape.txt
+++ b/Documentation/ide/ide-tape.txt
@@ -1,67 +1,65 @@
-/*
- * IDE ATAPI streaming tape driver.
- *
- * This driver is a part of the Linux ide driver.
- *
- * The driver, in co-operation with ide.c, basically traverses the
- * request-list for the block device interface. The character device
- * interface, on the other hand, creates new requests, adds them
- * to the request-list of the block device, and waits for their completion.
- *
- * The block device major and minor numbers are determined from the
- * tape's relative position in the ide interfaces, as explained in ide.c.
- *
- * The character device interface consists of the following devices:
- *
- * ht0		major 37, minor 0	first  IDE tape, rewind on close.
- * ht1		major 37, minor 1	second IDE tape, rewind on close.
- * ...
- * nht0		major 37, minor 128	first  IDE tape, no rewind on close.
- * nht1		major 37, minor 129	second IDE tape, no rewind on close.
- * ...
- *
- * The general magnetic tape commands compatible interface, as defined by
- * include/linux/mtio.h, is accessible through the character device.
- *
- * General ide driver configuration options, such as the interrupt-unmask
- * flag, can be configured by issuing an ioctl to the block device interface,
- * as any other ide device.
- *
- * Our own ide-tape ioctl's can be issued to either the block device or
- * the character device interface.
- *
- * Maximal throughput with minimal bus load will usually be achieved in the
- * following scenario:
- *
- *	1.	ide-tape is operating in the pipelined operation mode.
- *	2.	No buffering is performed by the user backup program.
- *
- * Testing was done with a 2 GB CONNER CTMA 4000 IDE ATAPI Streaming Tape Drive.
- *
- * Here are some words from the first releases of hd.c, which are quoted
- * in ide.c and apply here as well:
- *
- * | Special care is recommended.  Have Fun!
- *
- *	Possible improvements.
- *
- *	1.	Support for the ATAPI overlap protocol.
- *
- *		In order to maximize bus throughput, we currently use the DSC
- *		overlap method which enables ide.c to service requests from the
- *		other device while the tape is busy executing a command. The
- *		DSC overlap method involves polling the tape's status register
- *		for the DSC bit, and servicing the other device while the tape
- *		isn't ready.
- *
- *		In the current QIC development standard (December 1995),
- *		it is recommended that new tape drives will *in addition*
- *		implement the ATAPI overlap protocol, which is used for the
- *		same purpose - efficient use of the IDE bus, but is interrupt
- *		driven and thus has much less CPU overhead.
- *
- *		ATAPI overlap is likely to be supported in most new ATAPI
- *		devices, including new ATAPI cdroms, and thus provides us
- *		a method by which we can achieve higher throughput when
- *		sharing a (fast) ATA-2 disk with any (slow) new ATAPI device.
- */
+IDE ATAPI streaming tape driver.
+
+This driver is a part of the Linux ide driver.
+
+The driver, in co-operation with ide.c, basically traverses the
+request-list for the block device interface. The character device
+interface, on the other hand, creates new requests, adds them
+to the request-list of the block device, and waits for their completion.
+
+The block device major and minor numbers are determined from the
+tape's relative position in the ide interfaces, as explained in ide.c.
+
+The character device interface consists of the following devices:
+
+ht0		major 37, minor 0	first  IDE tape, rewind on close.
+ht1		major 37, minor 1	second IDE tape, rewind on close.
+...
+nht0		major 37, minor 128	first  IDE tape, no rewind on close.
+nht1		major 37, minor 129	second IDE tape, no rewind on close.
+...
+
+The general magnetic tape commands compatible interface, as defined by
+include/linux/mtio.h, is accessible through the character device.
+
+General ide driver configuration options, such as the interrupt-unmask
+flag, can be configured by issuing an ioctl to the block device interface,
+as any other ide device.
+
+Our own ide-tape ioctl's can be issued to either the block device or
+the character device interface.
+
+Maximal throughput with minimal bus load will usually be achieved in the
+following scenario:
+
+     1.	ide-tape is operating in the pipelined operation mode.
+     2.	No buffering is performed by the user backup program.
+
+Testing was done with a 2 GB CONNER CTMA 4000 IDE ATAPI Streaming Tape Drive.
+
+Here are some words from the first releases of hd.c, which are quoted
+in ide.c and apply here as well:
+
+| Special care is recommended.  Have Fun!
+
+Possible improvements:
+
+1. Support for the ATAPI overlap protocol.
+
+In order to maximize bus throughput, we currently use the DSC
+overlap method which enables ide.c to service requests from the
+other device while the tape is busy executing a command. The
+DSC overlap method involves polling the tape's status register
+for the DSC bit, and servicing the other device while the tape
+isn't ready.
+
+In the current QIC development standard (December 1995),
+it is recommended that new tape drives will *in addition*
+implement the ATAPI overlap protocol, which is used for the
+same purpose - efficient use of the IDE bus, but is interrupt
+driven and thus has much less CPU overhead.
+
+ATAPI overlap is likely to be supported in most new ATAPI
+devices, including new ATAPI cdroms, and thus provides us
+a method by which we can achieve higher throughput when
+sharing a (fast) ATA-2 disk with any (slow) new ATAPI device.
-- 
1.5.4.1

