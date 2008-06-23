Return-Path: <linux-kernel-owner+w=401wt.eu-S1757995AbYFWAKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995AbYFWAKS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 20:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbYFWAKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 20:10:00 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:63335 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996AbYFWAJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 20:09:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=hCGglsw2RvHec1iOMfs2qBI39AZWpBYS7ehZcTVK9c2SlVdL+sGYuMtNu6t4QH0AvE
         Doh8htr/hLFoQno6g7UB0/sEKsK6Fg7zmq7PTP8nbpuOEn3ZXWnns0/YgFp53KxZOnim
         VJv1EoMDDakYyEqKTBAY4RwOIpJZzVt8jho58=
Date: Mon, 23 Jun 2008 04:05:40 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Remove Module.markers during mrproper
Message-ID: <20080623000540.GA11518@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Makefile
+++ b/Makefile
@@ -1115,7 +1115,7 @@ MRPROPER_FILES += .config .config.old include/asm .version .old_version \
                   include/linux/autoconf.h include/linux/version.h      \
                   include/linux/utsrelease.h                            \
                   include/linux/bounds.h include/asm*/asm-offsets.h     \
-		  Module.symvers tags TAGS cscope*
+		  Module.symvers Module.markers tags TAGS cscope*
 
 # clean - Delete most, but leave enough to build external modules
 #

