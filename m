Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbYH1RHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbYH1RHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 13:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYH1RHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 13:07:43 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:54777 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbYH1RHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 13:07:43 -0400
Date: Thu, 28 Aug 2008 14:07:26 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org
Subject: PATCH: Kbuild: mkspec has to include /lib/firmware contents
Message-ID: <20080828140726.2feee90b@doriath.conectiva>
Organization: Mandriva
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.7; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We have to include the contents of /lib/firmware directory when building
the RPM package, otherwise the build will fail because of unpackaged
files.

Signed-off-by: Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>
---
 scripts/package/mkspec |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/package/mkspec b/scripts/package/mkspec
index ffd61fe..4f5d8cd 100755
--- a/scripts/package/mkspec
+++ b/scripts/package/mkspec
@@ -92,5 +92,6 @@ echo "%files"
 echo '%defattr (-, root, root)'
 echo "%dir /lib/modules"
 echo "/lib/modules/$KERNELRELEASE"
+echo "/lib/firmware/*"
 echo "/boot/*"
 echo ""
-- 
1.5.6



-- 
Luiz Fernando N. Capitulino
