Return-Path: <linux-kernel-owner+w=401wt.eu-S1757480AbXLWByi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480AbXLWByi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 20:54:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757090AbXLWByY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 20:54:24 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:51028 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756873AbXLWByW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 20:54:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=h9Qj1yELI7Zdz/dEcoySiayWOT9Yl8cWiVLdgkpPqhNMtQfYhQvSWhoZdB8NY4fxdJZw+j4Mi4eLT8w/XSv96nOXor1+EMI0moswoNeEknP/ofnpcOGQXUjNYLEWeKfXhys98EmuMhAru3o/JjnlMnrFwPEFbUMtWNo/6J8raag=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 13/24] udf: remove unused macros
Date: Sun, 23 Dec 2007 02:51:03 +0100
Message-Id: <1198374674-12128-14-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
References: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
CC: Jan Kara <jack@suse.cz>
---
 fs/udf/udf_sb.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index a9ff8fb..8683b71 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -167,13 +167,9 @@ static inline struct logicalVolIntegrityDescImpUse *udf_sb_lvidiu(struct super_b
 #define UDF_SB_BITMAP(X,Y,Z,I)			( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_block_bitmap[I] )
 #define UDF_SB_BITMAP_NR_GROUPS(X,Y,Z)		( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_nr_groups )
 
-#define UDF_SB_UMASK(X)				( udf_sb(X)->s_umask )
-#define UDF_SB_GID(X)				( udf_sb(X)->s_gid )
-#define UDF_SB_UID(X)				( udf_sb(X)->s_uid )
 #define UDF_SB_RECORDTIME(X)			( udf_sb(X)->s_recordtime )
 #define UDF_SB_SERIALNUM(X)			( udf_sb(X)->s_serialnum )
 #define UDF_SB_UDFREV(X)			( udf_sb(X)->s_udfrev )
-#define UDF_SB_FLAGS(X)				( udf_sb(X)->s_flags )
 #define UDF_SB_VAT(X)				( udf_sb(X)->s_vat )
 
 #endif /* __LINUX_UDF_SB_H */
-- 
1.5.3.4

