Return-Path: <linux-kernel-owner+w=401wt.eu-S1758283AbZLNVeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283AbZLNVeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 16:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871AbZLNVeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 16:34:20 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:59702 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440AbZLNVeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 16:34:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=fca8WIWcLMJH71AaqqN7UgOSlt6Ybg9hODvZJ4doVEcrXaDQnV+ECTErdxhQrU69W4
         mXKjlgfmx5lRY4N2wBQTpKayVXWNE11qbSfQvuTlyAYYDiTNUsa/pfbh2XHLej0yBmuJ
         h6fjqq/hM2OKEFBCPG18C91r/NdpBdMVAeTuI=
Date: Mon, 14 Dec 2009 22:34:13 +0100
From: Luca Tettamanti <kronos.it@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH] Document awk requirements
Message-ID: <20091214213413.GA9816@nb-core2.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
current -git kernel fails to build with this error message:

  GEN     arch/x86/lib/inat-tables.c
  Error: Your awk doesn't support charactor-class.

mawk is installed; it appears that gawk is required, so:
---
Gnu awk is required for generating arch/x86/lib/inat-tables.c

Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
---

 Documentation/Changes |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/Changes b/Documentation/Changes
index 6d0f1ef..53fd218 100644
--- a/Documentation/Changes
+++ b/Documentation/Changes
@@ -49,6 +49,7 @@ o  oprofile               0.9                     # oprofiled --version
 o  udev                   081                     # udevinfo -V
 o  grub                   0.93                    # grub --version
 o  mcelog		  0.6
+o  Gnu awk                3.1.5                   # awk --version   
 
 Kernel compilation
 ==================
