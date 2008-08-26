Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbYHZTog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbYHZTog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755870AbYHZToA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:44:00 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:58442 "EHLO
	camus.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760AbYHZTn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 15:43:58 -0400
From: Eric Anholt <eric@anholt.net>
To: linux-kernel@vger.kernel.org
Cc: Keith Packard <keithp@keithp.com>, Eric Anholt <eric@anholt.net>
Subject: [PATCH] Export shmem_file_setup for DRM-GEM
Date: Tue, 26 Aug 2008 12:43:07 -0700
Message-Id: <1219779789-8368-2-git-send-email-eric@anholt.net>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1219779789-8368-1-git-send-email-eric@anholt.net>
References: <1219779789-8368-1-git-send-email-eric@anholt.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keith Packard <keithp@keithp.com>

GEM needs to create shmem files to back buffer objects.  Though currently
creation of files for objects could have been driven from userland, the
modesetting work will require allocation of buffer objects before userland
is running, for boot-time message display.

Signed-off-by: Eric Anholt <eric@anholt.net>
---
 mm/shmem.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 04fb4f1..515909d 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2582,6 +2582,7 @@ put_memory:
 	shmem_unacct_size(flags, size);
 	return ERR_PTR(error);
 }
+EXPORT_SYMBOL(shmem_file_setup);
 
 /**
  * shmem_zero_setup - setup a shared anonymous mapping
-- 
1.5.6.3

