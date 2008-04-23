Return-Path: <linux-kernel-owner+w=401wt.eu-S1756265AbYDWXCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756265AbYDWXCH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 19:02:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbYDWXBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 19:01:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:3983 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbYDWXBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 19:01:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:user-agent:mime-version:content-type:from;
        b=g1L/kH65FPYzmGCa0E1PsEttQyyWerzc74wefXTCI7eJTjlZWS5e1XLZnH6wu49ZCZrpYRBeqikKxLDFP17URBR4fKL6xSe+ns3m4tNDY26IEHd0nCoNzuHC+/lC8qM2P1jRdno3PrhUsAvMPvrT6EPSn9hi6seoOed5Rb9kMd0=
Date: Thu, 24 Apr 2008 01:01:59 +0200 (CEST)
To: linux-kernel@vger.kernel.org
cc: Krishna Balasubramanian <balasub@cis.ohio-state.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH] Let SYSVIPC default to 'y'
Message-ID: <alpine.LNX.1.00.0804240057240.2438@dragon.funnycrock.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: Jesper Juhl <jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SYSVIPC is a pretty crucial feature that I doubt very much if anyone 
except embedded people should even consider disabling - it simply 
breaks too much software for a Linux box to really be useful without it, 
for most purposes.
For that reason I find it quite odd that the feature defaults to 'No' 
currently.  I really cannot see any reason why we wouldn't want this to 
default to 'Yes', so this patch changes the default by adding 'default y' 
to Kconfig.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/init/Kconfig b/init/Kconfig
index ba3a389..023b2b6 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -112,6 +112,7 @@ config SWAP
 
 config SYSVIPC
 	bool "System V IPC"
+	default y
 	---help---
 	  Inter Process Communication is a suite of library functions and
 	  system calls which let processes (running programs) synchronize and


