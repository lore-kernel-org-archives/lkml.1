Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbZJPVPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbZJPVPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 17:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755029AbZJPVPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 17:15:51 -0400
Received: from maila.microsoft.com ([131.107.115.212]:2904 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294AbZJPVPf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 17:15:35 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Tom Hanrahan <hanrahat@microsoft.com>, Hashir Abdi <habdi@microsoft.com>,
       Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 1/1] Staging: hv: Fix vmbus load hang caused by faulty data
 packing
Thread-Topic: [PATCH 1/1] Staging: hv: Fix vmbus load hang caused by faulty
 data packing
Thread-Index: AQHKTpzl6vXte6ymzEOsBqz8G3U58w==
Date: Fri, 16 Oct 2009 20:11:36 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C5620E7B5F30@TK5EX14MBXC114.redmond.corp.microsoft.com>
References: <1FB5E1D5CA062146B38059374562DF7212DEE3EC@TK5EX14MBXC130.redmond.corp.microsoft.com>
In-Reply-To: <1FB5E1D5CA062146B38059374562DF7212DEE3EC@TK5EX14MBXC130.redmond.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 From: Hank Janssen <hjanssen@microsoft.com>

Fix vmbus load hang caused by wrong data packing.
This fix needs to be applied to 2.6.32 as well.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Hank Janssen<hjanssen@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

---
diff --git a/drivers/staging/hv/ChannelMgmt.h b/drivers/staging/hv/ChannelMgmt.h
index a839d8f..2782328 100644
--- a/drivers/staging/hv/ChannelMgmt.h
+++ b/drivers/staging/hv/ChannelMgmt.h
@@ -54,7 +54,7 @@ enum vmbus_channel_message_type {
 	ChannelMessageViewRangeRemove		= 18,
 #endif
 	ChannelMessageCount
-} __attribute__((packed));
+};
 
 struct vmbus_channel_message_header {
 	enum vmbus_channel_message_type MessageType;

