Return-Path: <linux-kernel-owner+w=401wt.eu-S1761506AbYFZTyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761506AbYFZTyu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755894AbYFZTyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:54:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:33379 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755054AbYFZTyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:54:40 -0400
From: Bernhard Walle <bwalle@suse.de>
To: kexec@lists.infradead.org
Cc: vgoyal@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org,
       Bernhard Walle <bwalle@suse.de>
Subject: [PATCH] x86: Fix documentation bug about relocatability
Date: Thu, 26 Jun 2008 21:55:18 +0200
Message-Id: <1214510118-21405-1-git-send-email-bwalle@suse.de>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a small bug in documentation: x86_64 also has now
the ability to build a relocatable kernel.


Signed-off-by: Bernhard Walle <bwalle@suse.de>
---
 Documentation/kdump/kdump.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/kdump/kdump.txt b/Documentation/kdump/kdump.txt
index b8e52c0..9691c7f 100644
--- a/Documentation/kdump/kdump.txt
+++ b/Documentation/kdump/kdump.txt
@@ -109,7 +109,7 @@ There are two possible methods of using Kdump.
 2) Or use the system kernel binary itself as dump-capture kernel and there is
    no need to build a separate dump-capture kernel. This is possible
    only with the architecutres which support a relocatable kernel. As
-   of today i386 and ia64 architectures support relocatable kernel.
+   of today, i386, x86_64 and ia64 architectures support relocatable kernel.
 
 Building a relocatable kernel is advantageous from the point of view that
 one does not have to build a second kernel for capturing the dump. But
-- 
1.5.6

