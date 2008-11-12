Return-Path: <linux-kernel-owner+w=401wt.eu-S1752060AbYKLMwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbYKLMwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 07:52:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbYKLMwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 07:52:30 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33946 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbYKLMw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 07:52:29 -0500
Date: Wed, 12 Nov 2008 10:52:12 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] markers: Add missing stdargs.h include, needed due to
	va_list usage
Message-ID: <20081112125212.GA13263@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://oops.ghostprotocols.net:81/blog
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/include/linux/marker.h b/include/linux/marker.h
index 889196c..6213b5e 100644
--- a/include/linux/marker.h
+++ b/include/linux/marker.h
@@ -12,6 +12,7 @@
  * See the file COPYING for more details.
  */
 
+#include <stdarg.h>
 #include <linux/types.h>
 
 struct module;
