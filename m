Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbYHBXES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbYHBXES (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 19:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbYHBXEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 19:04:06 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:12413 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbYHBXEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 19:04:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=RzFu/5xN3db/xGVPaCXC/KeivVMgMa7JHH8YpAsb3El21pUoMSp1RpSOK2kj8bHVah
         tRfsQiYGYyR31SwP2LFu3FysfuC7wmlC4IVMPUrXVDd3wt8BVkWHU9OLxdAGtyL9wd3y
         cMahNIH77djDToJBILHOIl3hu+N8bIT9wWA3c=
Date: Sun, 3 Aug 2008 03:03:57 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: dwmw2@infradead.org, tim.bird@am.sony.com, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/video/console/promcon.c: fix build error
Message-ID: <20080802230357.GE4856@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>

drivers/video/console/promcon.c: fix build error

drivers/video/console/promcon.c:158: error: implicit declaration of
function 'con_protect_unimap'

Introduced by commit 4744b43431e8613f920c5cba88346756f53c5165

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Tim Bird <tim.bird@am.sony.com>
---

 include/linux/vt_kern.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/vt_kern.h b/include/linux/vt_kern.h
index 8c8119f..1c78d56 100644
--- a/include/linux/vt_kern.h
+++ b/include/linux/vt_kern.h
@@ -86,6 +86,7 @@ int con_copy_unimap(struct vc_data *dst_vc, struct vc_data *src_vc);
 #define con_copy_unimap(d, s) (0)
 #define con_get_unimap(vc, ct, uct, list) (-EINVAL)
 #define con_free_unimap(vc) do { ; } while (0)
+#define con_protect_unimap(vc, rdonly) do { ; } while (0)
 
 #define vc_translate(vc, c) (c)
 #endif
