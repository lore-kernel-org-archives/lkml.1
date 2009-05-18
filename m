Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208AbZERPj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbZERPj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 11:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751090AbZERPjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 11:39:49 -0400
Received: from os.inf.tu-dresden.de ([141.76.48.99]:43869 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbZERPjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 11:39:49 -0400
X-Greylist: delayed 1552 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 May 2009 11:39:48 EDT
Date: Mon, 18 May 2009 17:13:55 +0200
From: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation: make version fix
Message-ID: <20090518151355.GE15196@os.inf.tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The Makefiles in the build directories use the internal make
variable MAKEFILE_LIST which is available from make 3.80 only. 



Signed-off-by: Adam Lackorzynski <adam@os.inf.tu-dresden.de>

---
 Documentation/Changes |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/Changes b/Documentation/Changes
index b95082b..112e765 100644
--- a/Documentation/Changes
+++ b/Documentation/Changes
@@ -29,7 +29,7 @@ hardware, for example, you probably needn't concern yourself with
 isdn4k-utils.
 
 o  Gnu C                  3.2                     # gcc --version
-o  Gnu make               3.79.1                  # make --version
+o  Gnu make               3.80                    # make --version
 o  binutils               2.12                    # ld -v
 o  util-linux             2.10o                   # fdformat --version
 o  module-init-tools      0.9.10                  # depmod -V
@@ -61,7 +61,7 @@ computer.
 Make
 ----
 
-You will need Gnu make 3.79.1 or later to build the kernel.
+You will need Gnu make 3.80 or later to build the kernel.
 
 Binutils
 --------

Adam
-- 
Adam                 adam@os.inf.tu-dresden.de
  Lackorzynski         http://os.inf.tu-dresden.de/~adam/
