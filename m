Return-Path: <linux-kernel-owner+w=401wt.eu-S1423728AbXD3Vt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423728AbXD3Vt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 17:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423735AbXD3Vt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 17:49:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423728AbXD3Vt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 17:49:26 -0400
Date: Mon, 30 Apr 2007 17:47:52 -0400
From: Don Zickus <dzickus@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: nagar@watson.ibm.com
Subject: [PATCH] add taskstats.h to headers package
Message-ID: <20070430214752.GE21723@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

taskstats.h is missing from the kernel headers package.  It was designed
to be used from userland, so it should be safe.

Signed-off-by: Don Zickus <dzickus@redhat.com>


diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 4ff0f57..b5f9a62 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -317,6 +317,7 @@ unifdef-y += soundcard.h
 unifdef-y += stat.h
 unifdef-y += stddef.h
 unifdef-y += sysctl.h
+unifdef-y += taskstats.h
 unifdef-y += tcp.h
 unifdef-y += time.h
 unifdef-y += timex.h
