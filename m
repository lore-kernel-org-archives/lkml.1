Return-Path: <linux-kernel-owner+w=401wt.eu-S1759426AbZCZUwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426AbZCZUwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 16:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756057AbZCZUwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 16:52:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34957 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751862AbZCZUwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 16:52:03 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] vfat: Note the NLS requirement
To: linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp
Date: Thu, 26 Mar 2009 20:53:00 +0000
Message-ID: <20090326205256.5293.35764.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Close bug #4754

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 fs/fat/Kconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)


diff --git a/fs/fat/Kconfig b/fs/fat/Kconfig
index d0a69ff..182f9ff 100644
--- a/fs/fat/Kconfig
+++ b/fs/fat/Kconfig
@@ -95,3 +95,6 @@ config FAT_DEFAULT_IOCHARSET
 	  Note that "utf8" is not recommended for FAT filesystems.
 	  If unsure, you shouldn't set "utf8" here.
 	  See <file:Documentation/filesystems/vfat.txt> for more information.
+
+	  Enable any character sets you need in File Systems/Native Language
+	  Support.

