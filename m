Return-Path: <linux-kernel-owner+w=401wt.eu-S1751054AbZHIPZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751054AbZHIPZ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 11:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbZHIPZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 11:25:28 -0400
Received: from smtp.nokia.com ([192.100.122.233]:16638 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbZHIPZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 11:25:27 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 09 Aug 2009 20:16:52 +0300
Message-Id: <20090809171652.20934.75047.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBI changes for 2.6.31-rc6
X-OriginalArrivalTime: 09 Aug 2009 15:25:14.0825 (UTC) FILETIME=[97F24B90:01CA1905]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here are two more UBI bugfixes. One patch fixes double free
on error path and one makes sure UBI supports older flash
images correctly.

The following changes since commit 4be3bd7849165e7efa6b0b35a23d6a3598d97465:
  Linus Torvalds (1):
        Linux 2.6.31-rc4

are available in the git repository at:

  git://git.infradead.org/ubi-2.6.git for-linus

Adrian Hunter (2):
      UBI: fix double free on error path
      UBI: compatible fallback in absense of sequence numbers

 drivers/mtd/ubi/eba.c  |    1 +
 drivers/mtd/ubi/scan.c |   13 ++++++++++++-

Thanks,
Artem.
