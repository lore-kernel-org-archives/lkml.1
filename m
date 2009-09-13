Return-Path: <linux-kernel-owner+w=401wt.eu-S1755040AbZIMTj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbZIMTj2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 15:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754980AbZIMTj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 15:39:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:36490 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942AbZIMTj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 15:39:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eIvtsiqkFL2kb0Xw2RtNbooAuszr0BXdGJLwnsTEEso8CuyDmwUma5kFdOgnAjq3YS
         x5T67eo2NNwPTtuAmbiojcmtMvXk//kqDzJvyhG/bYuA34Y/NWOeJwsv6tCSyfXSOQhv
         A+27SXO/zLirSAng3ycdhi9fnqYn4Q1uViXnw=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH 3/5] kbuild: mkcompile_h: trivial cleanups
Date: Sun, 13 Sep 2009 22:38:25 +0300
Message-Id: <1252870707-4824-4-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.6.5.rc1
In-Reply-To: <1252870707-4824-3-git-send-email-felipe.contreras@gmail.com>
References: <1252870707-4824-1-git-send-email-felipe.contreras@gmail.com>
 <1252870707-4824-2-git-send-email-felipe.contreras@gmail.com>
 <1252870707-4824-3-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UTS_TRUNCATTE is simpler this way, and now editors idetify this as a
shell script.

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 scripts/mkcompile_h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/scripts/mkcompile_h b/scripts/mkcompile_h
index 2e09f4a..7ab9c52 100755
--- a/scripts/mkcompile_h
+++ b/scripts/mkcompile_h
@@ -1,3 +1,5 @@
+#!/bin/sh
+
 TARGET=$1
 ARCH=$2
 SMP=$3
@@ -50,7 +52,7 @@ UTS_VERSION="$UTS_VERSION $CONFIG_FLAGS $TIMESTAMP"
 # Truncate to maximum length
 
 UTS_LEN=64
-UTS_TRUNCATE="sed -e s/\(.\{1,$UTS_LEN\}\).*/\1/"
+UTS_TRUNCATE="cut -b -$UTS_LEN"
 
 # Generate a temporary compile.h
 
-- 
1.6.5.rc1

