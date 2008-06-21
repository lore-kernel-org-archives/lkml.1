Return-Path: <linux-kernel-owner+w=401wt.eu-S1753728AbYFUOKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbYFUOKx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 10:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbYFUOKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 10:10:45 -0400
Received: from [194.117.236.238] ([194.117.236.238]:54428 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbYFUOKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 10:10:44 -0400
Date: Sat, 21 Jun 2008 17:10:27 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: tzanussi@gmail.com
Cc: penberg@cs.helsinki.fi, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, compudj@krystal.dyndns.org,
       vegard.nossum@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] Unignore vmlinux.lds.h from Git.
Message-ID: <20080621171027.3e4542d6@linux360.ro>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added !vmlinux.lds.h to .gitignore because it would otherwise be ignored.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
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

