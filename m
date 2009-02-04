Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbZBDOte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbZBDOte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 09:49:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbZBDOt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 09:49:26 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:27821 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbZBDOtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 09:49:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=OOJBQ/8CkkG0HC8FICZ+QvT082GxqmfWt1I82GYpYp9rGcj1ZwAUlXCLKFohoYNUx3
         sxjNRTfRDCgNI9C2qoclQVnoLJ4Is9a7gFujVy4NmWUDb/OLNScjAF9ESFb4jUwmg7Yf
         hL3UM1/cBz0LQ1IdHpeuowOwxgMaIIQ+ux8Ac=
Date: Wed, 4 Feb 2009 17:49:20 +0300
From: Alexander Beregalov <a.beregalov@gmail.com>
To: swhiteho@redhat.com, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] gfs2/ops_file.c: fix build breakage
Message-ID: <20090204144920.GA13319@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fs/gfs2/ops_file.c:746: error: 'generic_setlease' undeclared here (not
in a function)

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 fs/gfs2/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/gfs2/Kconfig b/fs/gfs2/Kconfig
index 3a981b7..97cefdf 100644
--- a/fs/gfs2/Kconfig
+++ b/fs/gfs2/Kconfig
@@ -7,6 +7,7 @@ config GFS2_FS
 	select IP_SCTP if DLM_SCTP
 	select FS_POSIX_ACL
 	select CRC32
+	select FILE_LOCKING
 	help
 	  A cluster filesystem.
 
