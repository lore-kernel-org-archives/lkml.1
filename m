Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbZGYCLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbZGYCLN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 22:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755147AbZGYCLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 22:11:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35005 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbZGYCLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 22:11:11 -0400
Date: Fri, 24 Jul 2009 22:11:02 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: giometti@enneenne.com
Subject: [PATCH] pps.h needs <linux/types.h>
Message-ID: <20090725021102.GB6942@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, giometti@enneenne.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found with make headers_check

/usr/include/linux/pps.h:52: found __[us]{8,16,32,64} type without #include <linux/types.h>

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/include/linux/pps.h b/include/linux/pps.h
index cfe5c72..0194ab0 100644
--- a/include/linux/pps.h
+++ b/include/linux/pps.h
@@ -22,6 +22,8 @@
 #ifndef _PPS_H_
 #define _PPS_H_
 
+#include <linux/types.h>
+
 #define PPS_VERSION		"5.3.6"
 #define PPS_MAX_SOURCES		16		/* should be enough... */
 
