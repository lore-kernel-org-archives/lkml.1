Return-Path: <linux-kernel-owner+w=401wt.eu-S1765146AbZFLVqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765146AbZFLVqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 17:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758436AbZFLVqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 17:46:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48890 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757791AbZFLVqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 17:46:07 -0400
From: Izik Eidus <ieidus@redhat.com>
To: hugh.dickins@tiscali.co.uk
Cc: linux-kernel@vger.kernel.org, Izik Eidus <ieidus@redhat.com>
Subject: [PATCH 0/3] ksm: write protect pages from inside ksm
Date: Sat, 13 Jun 2009 00:44:57 +0300
Message-Id: <1244843100-4128-1-git-send-email-ieidus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh, so untill here we are sync,

Question is what you want me to do now?,
(Beacuse we are skipping 2.6.31, It is ok to you to tell me something
 like: "Shut up and let me see what i can get with this madvise" -
 that from one side.
 From another side if you want me to do anything please say.

Thanks.

Izik Eidus (3):
  ksm: remove ksm from being a module.
  ksm: remove page_wrprotect() from rmap.c
  withdraw ksm-add-page_wrprotect-write-protecting-page.patch

 include/linux/mm.h   |    2 +-
 include/linux/rmap.h |   12 ----
 mm/Kconfig           |    5 +-
 mm/ksm.c             |   92 +++++++++++++++++++++++----------
 mm/memory.c          |    2 +-
 mm/rmap.c            |  139 --------------------------------------------------
 6 files changed, 69 insertions(+), 183 deletions(-)

