Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbYBINfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbYBINfH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 08:35:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbYBINey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 08:34:54 -0500
Received: from mail.windriver.com ([147.11.1.11]:60343 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754587AbYBINex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 08:34:53 -0500
From: jason.wessel@windriver.com
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] kgdb 2.6.25 version
Date: Sat,  9 Feb 2008 07:35:06 -0600
Message-Id: <1202564114-18587-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.4
X-OriginalArrivalTime: 09 Feb 2008 13:34:52.0368 (UTC) FILETIME=[8CB24D00:01C86B20]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per reqest on lkml, here are the individual kgdb patches
targeted at 2.6.25.

The kgdb tree has been collapsed review.  It includes
the kgdb core, the x86 arch, the kgdb8250 uart driver
and the kgdb console sharing driver.

Since the last time the kgdb patches were posted to LKML
several months ago, the kgdb core has undergone some
significant cleanup, as well as the kgdb I/O driver
interface.

All the kgdb hooks are initialized dynamically only when a
kgdb I/O module is configured. When not configured
kgdb will not exist in any kernel execution path.

Further comments, questions and patches are certainly
welcome.

Thanks,
Jason.


