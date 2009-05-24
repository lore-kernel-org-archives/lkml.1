Return-Path: <linux-kernel-owner+w=401wt.eu-S1758690AbZEXCkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbZEXCkv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 22:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755667AbZEXCiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 22:38:13 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1432 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865AbZEXCiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 22:38:04 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 09/18] scripts/get_maintainer.pl - Allow 8 bit characters in email addresses
Date: Sat, 23 May 2009 19:37:40 -0700
Message-Id: <a4a70eba6718efa5e25baa91a93f76fe4c96824c.1243131992.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1243131992.git.joe@perches.com>
References: <cover.1243131992.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 9de864f..951cb95 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -57,7 +57,7 @@ my $penguin_chiefs = "\(" . join("|",@penguin_chief_names) . "\)";
 
 # rfc822 email address - preloaded methods go here.
 my $rfc822_lwsp = "(?:(?:\\r\\n)?[ \\t])";
-my $rfc822_char = '[\\000-\\177]';
+my $rfc822_char = '[\\000-\\377]';
 
 if (!GetOptions(
 		'email!' => \$email,
-- 
1.6.3.1.10.g659a0.dirty

