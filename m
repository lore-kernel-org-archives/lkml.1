Return-Path: <linux-kernel-owner+w=401wt.eu-S1759379AbYFXRJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759379AbYFXRJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 13:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755523AbYFXRJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 13:09:04 -0400
Received: from mail.windriver.com ([147.11.1.11]:53583 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbYFXRJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 13:09:03 -0400
Message-ID: <48612A09.3000701@windriver.com>
Date: Tue, 24 Jun 2008 12:08:25 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] kgdb fixes for 2.6.26-rc7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jun 2008 17:08:24.0533 (UTC) FILETIME=[E9858850:01C8D61C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for_linus branch at:
 
git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git
for_linus


This is a minor doc update to fix a reported error as well as to
remove any reference to kgdboe, which is not in the main line kernel.
Also included is a fix to remove the last known kgdb sparse warning.

As of 2.6.26-rc7, all the known kgdb boot and test regressions which
were reported to me are closed.

Thanks,
Jason.

---
The following changes since commit 62786b9e81a2dbe9c073a2ade52d33a2627d6d85:

Jason Wessel (2):
      kgdb: documentation update - remove kgdboe
      kgdb: sparse fix

 Documentation/DocBook/kgdb.tmpl |   20 ++++++--------------
 kernel/kgdb.c                   |    3 ++-
 2 files changed, 8 insertions(+), 15 deletions(-)

