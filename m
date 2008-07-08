Return-Path: <linux-kernel-owner+w=401wt.eu-S1757979AbYGHMuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979AbYGHMuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 08:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756458AbYGHMsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 08:48:36 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:27592 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757856AbYGHMs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 08:48:28 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: monstr@seznam.cz, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, vapier.adi@gmail.com,
       alan@lxorguk.ukuu.org.uk, hpa@zytor.com, lethal@linux-sh.org,
       florian@openwrt.org
Subject: microblaze_v5: Status message
Date: Tue,  8 Jul 2008 13:59:00 +0200
Message-Id: <1215518398-5057-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

here is microblaze_v5 set of patches with initial port
for Microblaze CPU. I did some changes which was reported
to me. Please check your reported changes if there are in the pack.

The patches are also available at git.monstr.eu. (linux-microblaze.git
 master branch).

I got ACK from Steve Neuendorffer (xilinx guy) for this pack.

Changes in v5 pack:
      Add new dts v1 file
      clean autoconf.h and remove a.out.h
      remove internal.h library
      fix headers - add one definition
      remove dependency on asm/semaphore.h
      Clean make headers_check dependency
      Fix Kconfig issue
      Remove macros DEFINE and BLANK from asm-offsets.c
      Move asm code from asm-generic checksum.h
      Clean process for enabling possibility to use smp with MB
      Clean platform folder to generic dts
      current config file
      Clean ptrace for generic use
      Clean cmdline handling
      Fix traps.c

Thanks for your comments and ACKs. I'll add them to patches.

Best regards,
Michal Simek
www.monstr.eu



