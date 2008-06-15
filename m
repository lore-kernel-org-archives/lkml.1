Return-Path: <linux-kernel-owner+w=401wt.eu-S1758928AbYFOPFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928AbYFOPFz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 11:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758166AbYFOPFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 11:05:48 -0400
Received: from [194.117.236.238] ([194.117.236.238]:54300 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757693AbYFOPFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 11:05:47 -0400
Date: Sun, 15 Jun 2008 18:05:01 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: tzanussi@gmail.com, linux-kernel@vger.kernel.org
Cc: penberg@cs.helsinki.fi, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, compudj@krystal.dyndns.org
Subject: [PATCH 1/3] Unignore vmlinux.lds.h from Git.
Message-ID: <20080615180501.1181e659@linux360.ro>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added !vmlinux.lds.h to .gitignore because it would otherwise be ignored.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 .gitignore |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/.gitignore b/.gitignore
index d24ad50..9bb1cb6 100644
--- a/.gitignore
+++ b/.gitignore
@@ -26,6 +26,7 @@ tags
 TAGS
 vmlinux*
 !vmlinux.lds.S
+!vmlinux.lds.h
 System.map
 Module.markers
 Module.symvers
-- 
1.5.5.4

