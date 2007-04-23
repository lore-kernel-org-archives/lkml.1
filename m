Return-Path: <linux-kernel-owner+w=401wt.eu-S965701AbXDWKKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965701AbXDWKKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 06:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965712AbXDWKKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 06:10:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:18710 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965701AbXDWKKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 06:10:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Zv6rJi0m/w2InQC+N1V8WV+dAxqwEi26FjDby786ra2ahDhj8kdF7ji+jgusoL72wjJ8M+WaPRG7jYx8dGvh3v24x/3B1izAV8M8Dg5aZ2fSM/i9RnLYwHmu9eNdWYwI+Xwt0C4GWqiyY4hHpjqSxcPLBMXX4k9sv8lrv9YjhQY=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix chapter reference in CodingStyle
Date: Mon, 23 Apr 2007 12:10:22 +0200
User-Agent: KMail/1.9.6
Cc: Randy Dunlap <rdunlap@xenotime.net>, trivial@kernel.org,
       jesper.juhl@gmail.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704231210.23105.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

commit 226a6b84aaaf1fac7a5d41cf4e7387fd9ba895d5 renumbered Chapter 11 in 
Documentation/CodingStyle to Chapter 12, but it didn't update the reference 
to that chapter further down in the file. This patch corrects the chapter 
reference.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
--- 

 Documentation/CodingStyle |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index 9069189..899777f 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -625,7 +625,7 @@ language.
 
 There appears to be a common misperception that gcc has a magic "make me
 faster" speedup option called "inline". While the use of inlines can be
-appropriate (for example as a means of replacing macros, see Chapter 11), it
+appropriate (for example as a means of replacing macros, see Chapter 12), it
 very often is not. Abundant use of the inline keyword leads to a much bigger
 kernel, which in turn slows the system as a whole down, due to a bigger
 icache footprint for the CPU and simply because there is less memory
