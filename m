Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270AbZICFfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbZICFfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 01:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbZICFfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 01:35:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45164 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233AbZICFfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 01:35:43 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: catalin.marinas@arm.com, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi, mcgrof@gmail.com,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 0/5] kmemleak: few small cleanups and clear command support
Date: Thu,  3 Sep 2009 01:35:35 -0400
Message-Id: <1251956140-5499-1-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.6.2.rc1.3.g81d3f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is my second revision, now tested. Does the job I was looking for.
I fixed two issues from my previous untested revision, I removed the scan
lock, and also fixed the strncmp() count.

My kmemleak output was too polluted to do on the fly debugging, adding
a clear command lets you test the sections you want when you want with
a cleared fresh list of kmemleak objects.

Still not sure who this goes through so sending this to Linus.

Luis R. Rodriguez (5):
  kmemleak: use bool for true/false questions
  kmemleak: add clear command support
  kmemleak: move common painting code together
  kmemleak: fix sparse warning over overshadowed flags
  kmemleak: fix sparse warning for static declarations

 Documentation/kmemleak.txt |   17 ++++++++++
 mm/kmemleak.c              |   72 ++++++++++++++++++++++++++++++-------------
 2 files changed, 67 insertions(+), 22 deletions(-)

