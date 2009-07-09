Return-Path: <linux-kernel-owner+w=401wt.eu-S1759382AbZGIFVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382AbZGIFVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 01:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbZGIFVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 01:21:09 -0400
Received: from smtp.nokia.com ([192.100.122.230]:22423 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbZGIFVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 01:21:08 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 09 Jul 2009 10:10:58 +0300
Message-Id: <20090709071058.10124.94970.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBIFS changes for 2.6.31-rc3
X-OriginalArrivalTime: 09 Jul 2009 05:20:29.0941 (UTC) FILETIME=[F9AA2250:01CA0054]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here are UBIFS fixes for mount regression, compilation warnings,
recovery amendments and dumps.

Please, pull from:

git://git.infradead.org/ubifs-2.6.git linux-next

The following changes since commit 8e4a718ff38d8539938ec3421935904c27e00c39:
  Linus Torvalds (1):
        Linux 2.6.31-rc2

Adrian Hunter (3):
      UBIFS: fix integer overflow warning
      UBIFS: fix 64-bit divisions in debug print
      UBIFS: minor spelling and grammar fixes

Artem Bityutskiy (10):
      UBIFS: improve debugging messaged
      UBIFS: slightly optimize write-buffer timer usage
      UBIFS: set write-buffer timout to 3-5 seconds
      UBIFS: few spelling fixes
      UBIFS: fix assertion warning
      MAINTAINERS: update ahunter's e-mail address
      UBIFS: dump a little more in case of corruptions
      UBIFS: small amendments in the LEB scanning code
      UBIFS: clean up free space checking
      UBIFS: fix corruption dump

Daniel Mack (1):
      UBIFS: allow more than one volume to be mounted

 MAINTAINERS         |    2 +-
 fs/ubifs/io.c       |   57 ++++++++++++++++++++++++--------------------------
 fs/ubifs/recovery.c |   57 +++++++++++++++++++++++++++++---------------------
 fs/ubifs/replay.c   |    9 ++++---
 fs/ubifs/scan.c     |   20 ++++++++++-------
 fs/ubifs/super.c    |   14 +++++++-----
 fs/ubifs/ubifs.h    |   11 ++++++---
 7 files changed, 93 insertions(+), 77 deletions(-)

Thanks,
Artem.
