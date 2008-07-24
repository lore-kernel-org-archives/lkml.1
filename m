Return-Path: <linux-kernel-owner+w=401wt.eu-S1754376AbYGXJiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbYGXJiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 05:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbYGXJiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 05:38:46 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:4730 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbYGXJip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 05:38:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=MNej1/1fyn1nK23axT0CaBAb7yJfZ16E/F7P8B7Ow8M7rGdnSSqI/tD5wEjV4e1rMx
         odXPz32D+QfZMkNu/XMir6QW5jGhqscz9eQyhG1KFtnngz6yE9yw1fCslubAFE1yagdu
         eMxQIUX6It4bRFSutzZXvKbt18n33gEZJzYAc=
Message-ID: <a1d7a2f20807240238r58b6e866u719806447476ac43@mail.gmail.com>
Date: Thu, 24 Jul 2008 11:38:45 +0200
From: "Jerome Arbez-Gindre" <jeromearbezgindre@gmail.com>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Subject: [patch] Add a BlackBoard user to connector
Cc: linux-kernel@vger.kernel.org, deweerdt@free.fr
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Evgeniy,

Here's an updated patch.

Add a BlackBoard user to connector. BlackBoard is part of the TSP
GPL sampling framework (http://savannah.nongnu.org/p/tsp)


Signed-off-by: Jerome Arbez-Gindre <jeromearbezgindre@gmail.com>

diff --git a/include/linux/connector.h b/include/linux/connector.h
index 96a89d3..d7ac97a 100644
--- a/include/linux/connector.h
+++ b/include/linux/connector.h
@@ -38,8 +38,9 @@
 #define CN_W1_VAL                      0x1
 #define CN_IDX_V86D                    0x4
 #define CN_VAL_V86D_UVESAFB            0x1
+#define CN_IDX_BB                      0x5

-#define CN_NETLINK_USERS               5
+#define CN_NETLINK_USERS               6

 /*
 * Maximum connector's message size.
