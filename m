Return-Path: <linux-kernel-owner+w=401wt.eu-S1763680AbYETJmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763680AbYETJmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 05:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbYETJm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 05:42:29 -0400
Received: from sineb-mail-1.sun.com ([192.18.19.6]:64968 "EHLO
	sineb-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbYETJm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 05:42:28 -0400
X-Greylist: delayed 1029 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 May 2008 05:42:28 EDT
Date: Thu, 22 May 2008 09:23:10 +0800
From: Jike Song <albcamus@gmail.com>
Subject: [PATCH] [.gitignore] match ncscope.out
To: sam@ravnborg.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Reply-to: albcamus@gmail.com
Message-id: <4834CAFE.2070607@gmail.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From e8e67fca3f9227b612a59d8afd0464222231e362 Mon Sep 17 00:00:00 2001
From: Jike Song <albcamus@gmail.com>
Date: Tue, 20 May 2008 16:15:05 +0800
Subject: [PATCH] [.gitignore] match ncscope.out

Sometimes I got this:

    $ git-status
    {snip}
    # On branch master
    # Untracked files:
    #   (use "git add <file>..." to include in what will be committed)
    #
    #       ncscope.out
    nothing added to commit but untracked files present (use "git add" 
to track)

Fix it.

Signed-off-by: Jike Song <albcamus@gmail.com>
---
 .gitignore |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/.gitignore b/.gitignore
index 090b293..a48b1e1 100644
--- a/.gitignore
+++ b/.gitignore
@@ -51,7 +51,7 @@ patches
 series
 
 # cscope files
-cscope.*
+*cscope.*
 
 *.orig
 *.rej
-- 
1.5.4.1

