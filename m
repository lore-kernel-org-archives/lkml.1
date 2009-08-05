Return-Path: <linux-kernel-owner+w=401wt.eu-S933222AbZHEBtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933222AbZHEBtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 21:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933104AbZHEBtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 21:49:11 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:55214 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933042AbZHEBtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 21:49:10 -0400
Date: Tue, 4 Aug 2009 18:48:59 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: [PATCH -mmotm] staging/udlfb: fix printk format warning
Message-Id: <20090804184859.2155e866.randy.dunlap@oracle.com>
In-Reply-To: <200908042125.n74LP9qY018119@imap1.linux-foundation.org>
References: <200908042125.n74LP9qY018119@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt005.oracle.com [141.146.116.14]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010206.4A78E508.0138:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warning: use %td for ptrdiff:

drivers/staging/udlfb/udlfb.h:209: warning: format '%d' expects type 'int', but argument 3 has type 'long int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/udlfb/udlfb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- mmotm-2009-0804-1422.orig/drivers/staging/udlfb/udlfb.h
+++ mmotm-2009-0804-1422/drivers/staging/udlfb/udlfb.h
@@ -205,7 +205,7 @@ static int dlfb_set_video_mode(struct dl
 
 			/* send */
 			ret = dlfb_bulk_msg(dev_info, bufptr - dev_info->buf);
-			printk("ret bulk 2: %d %d\n", ret,
+			printk("ret bulk 2: %d %td\n", ret,
 			       bufptr - dev_info->buf);
 
 			/* flush */




---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
