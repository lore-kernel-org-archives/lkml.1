Return-Path: <linux-kernel-owner+w=401wt.eu-S1755597AbYDXLTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbYDXLTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 07:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbYDXLS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 07:18:59 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:54503 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751581AbYDXLS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 07:18:59 -0400
Date: Thu, 24 Apr 2008 20:18:57 +0900 (JST)
Message-Id: <20080424.201857.183035295.ryov@valinux.co.jp>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Cc: agk@sourceware.org
Subject: [PATCH 0/2] dm-ioband: I/O bandwidth controller v0.0.4:
 Introduction
From: Ryo Tsuruta <ryov@valinux.co.jp>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This is dm-ioband version 0.0.4 release.

Dm-ioband is an I/O bandwidth controller implemented as a device-mapper
driver, which gives specified bandwidth to each job running on the same
physical device.

Changes since 0.0.3 (5th February):
   - Improve the performance when many processes are issuing I/Os
     simultaneously. 
   - Change the table format to fully support dmsetup table/load commands.
     The table format consists all configuration parameters.
   - Port to linux-2.6.25.

An administration tool is available. It makes it easy to configure
bandwidths of disk partitions.
You can download it and find the manual at
http://people.valinux.co.jp/~kaizuka/dm-ioband/iobandctl/

For more details, please refer to:
http://people.valinux.co.jp/~ryov/dm-ioband/

Thanks,
Ryo Tsuruta
