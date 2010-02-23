Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab0BXHOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:14:30 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:56211 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097Ab0BXHO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:14:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=V8ie2qFtsJtjv68F93KH0jV55KPx2ShZoH45b5owcz35ZBiDhnDW2MRnx8D6OJwtZN
         ECnnj/O2XPlGJ2Jq6FQC+pY/QtzB/N3yhyDtra6/xY05osgMR3BFWi3q6lafPoWgnobP
         Srhbpb0NTbm+JyD2av2j+pr2UFvifhkEr170I=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Serge E . Hallyn" <serue@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH 5/6] mqueue: fix typo "failues" -> "failures"
Date: Tue, 23 Feb 2010 04:04:27 -0300
Message-Id: <2251fc0ec62b0f8e9dd9147fabdbdad24aa9c467.1266907496.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
In-Reply-To: <cover.1266907495.git.andre.goddard@gmail.com>
References: <cover.1266907495.git.andre.goddard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
---
 ipc/mqueue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 906e873..e47c9eb 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -1297,7 +1297,7 @@ static int __init init_mqueue_fs(void)
 	if (mqueue_inode_cachep == NULL)
 		return -ENOMEM;
 
-	/* ignore failues - they are not fatal */
+	/* ignore failures - they are not fatal */
 	mq_sysctl_table = mq_register_sysctl_table();
 
 	error = register_filesystem(&mqueue_fs_type);
-- 
1.7.0.87.g0901d

