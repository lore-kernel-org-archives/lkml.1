Return-Path: <linux-kernel-owner+w=401wt.eu-S1761984AbXLMSY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761984AbXLMSY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 13:24:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754775AbXLMSYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 13:24:20 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:35541 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbXLMSYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 13:24:20 -0500
Date: Thu, 13 Dec 2007 19:26:09 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       Guillaume Chazarain <guichaz@yahoo.fr>
Subject: [GIT PATCH] kbuild fix
Message-ID: <20071213182609.GA12134@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

Please pull following fix:

Guillaume Chazarain (1):
      kbuild: re-enable Makefile generation in a new O=... directory

Pull from:
   ssh://master.kernel.org/pub/scm/linux/kernel/git/sam/fix-kbuild.git


	Sam

Diffstat + patch:

 scripts/mkmakefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/mkmakefile b/scripts/mkmakefile
index 9ad1bd7..e0f54b9 100644
--- a/scripts/mkmakefile
+++ b/scripts/mkmakefile
@@ -13,7 +13,7 @@
 test ! -r $2/Makefile -o -O $2/Makefile || exit 0
 # Only overwrite automatically generated Makefiles
 # (so we do not overwrite kernel Makefile)
-if ! grep -q Automatically $2/Makefile
+if test -e $2/Makefile && ! grep -q Automatically $2/Makefile
 then
 	exit 0
 fi


