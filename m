Return-Path: <linux-kernel-owner+w=401wt.eu-S1757036AbYBEKSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036AbYBEKSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 05:18:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbYBEKR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 05:17:59 -0500
Received: from fms-01.valinux.co.jp ([210.128.90.1]:39471 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753325AbYBEKR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 05:17:58 -0500
Date: Tue, 05 Feb 2008 19:17:35 +0900 (JST)
Message-Id: <20080205.191735.193708307.ryov@valinux.co.jp>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Cc: agk@redhat.com
Subject: [PATCH 0/2] dm-ioband v0.0.3: The I/O bandwidth controller:
 Introduction
From: Ryo Tsuruta <ryov@valinux.co.jp>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This is dm-ioband version 0.0.3 release.

Dm-ioband is an I/O bandwidth controller implemented as a device-mapper driver,
which gives specified bandwidth to each job running on the same physical
device.

Changes since 0.0.2 (23rd January):
   - Ported to linux-2.6.24.
   - Rename the name of this device-mapper device as "ioband."
   - The output format of "dmsetup table" can be recognized by "dmsetup
     create/load/reload."
   - Add a new feature to block processes requesting BIOs in case the number
     of the uncompleted BIOs becomes too large.
   - Gid can be used as an ioband group type.
   - Support "dmsetup suspend --noflush."
   - Fix the problem that "dmsetup detach" doesn't wait the completion of
     all the BIOs in the detaching group.
   - Fix the problem that "dmsetup message attach" can't accept ID 0.
   - Code cleanups. Use prefix "dm_" for the global symbols.
   - Add examples in the document.

Thanks,
Ryo Tsuruta
