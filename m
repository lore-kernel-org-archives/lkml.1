Return-Path: <linux-kernel-owner+w=401wt.eu-S1751626AbZJWJfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626AbZJWJfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 05:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbZJWJfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 05:35:54 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:51122 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbZJWJfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 05:35:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=MyficWWDXp6vX2XGGq3qYo7a9lE4Ful+ns1uM7B+YdXgFzx7/o/Ys5BepC0qAeg6F6
         OzP9otrfDm27dvCCzmpDmSeUSv4YvsbD+525OJy9GuZbrRetDCjfg4/NvHvbHcvVQQ8y
         jrS6Jf4/Z/Q6rsIZK7MAPwOBgvvjeLg7XQpz8=
Message-ID: <4AE17B62.1030701@gmail.com>
Date: Fri, 23 Oct 2009 11:46:10 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] get_maintainer: fix usage comment
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the `s' it just won't work.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index cdb44b6..4673873 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -5,8 +5,8 @@
 # Print selected MAINTAINERS information for
 # the files modified in a patch or for a file
 #
-# usage: perl scripts/get_maintainers.pl [OPTIONS] <patch>
-#        perl scripts/get_maintainers.pl [OPTIONS] -f <file>
+# usage: perl scripts/get_maintainer.pl [OPTIONS] <patch>
+#        perl scripts/get_maintainer.pl [OPTIONS] -f <file>
 #
 # Licensed under the terms of the GNU GPL License version 2
 
