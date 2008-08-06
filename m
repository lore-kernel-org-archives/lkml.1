Return-Path: <linux-kernel-owner+w=401wt.eu-S1758711AbYHFRNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711AbYHFRNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 13:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754606AbYHFRJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 13:09:01 -0400
Received: from xenotime.net ([66.160.160.81]:33196 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754416AbYHFRI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 13:08:58 -0400
Date: Wed, 6 Aug 2008 10:08:56 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: linux-kernel@vger.kernel.org
cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       mchehab@infradead.org
Subject: [PATCH] docbook: fix v4l fatal filename error
Message-ID: <Pine.LNX.4.64.0808061007160.11671@shark.he.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
cc: mchehab@infradead.org

docproc: /var/linsrc/lin2627-rc2/drivers/media/video/videodev.c: No such file or directory
make[1]: *** [Documentation/DocBook/videobook.xml] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/videobook.tmpl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Argh.  See Documentation/SubmitChecklist #11.

--- lin2627-rc2.orig/Documentation/DocBook/videobook.tmpl
+++ lin2627-rc2/Documentation/DocBook/videobook.tmpl
@@ -1648,7 +1648,7 @@ static struct video_buffer capture_fb;
 
   <chapter id="pubfunctions">
      <title>Public Functions Provided</title>
-!Edrivers/media/video/videodev.c
+!Edrivers/media/video/v4l2-dev.c
   </chapter>
 
 </book>
