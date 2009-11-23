Return-Path: <linux-kernel-owner+w=401wt.eu-S1757205AbZKWLFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205AbZKWLFB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:05:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757181AbZKWLFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:05:01 -0500
Received: from znsun1.ifh.de ([141.34.1.16]:62001 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756626AbZKWLFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:05:00 -0500
Date: Mon, 23 Nov 2009 12:04:57 +0100 (CET)
From: Patrick Boettcher <pboettcher@kernellabs.com>
X-X-Sender: pboettch@pub1.ifh.de
To: linux-kernel@vger.kernel.org
cc: Martin Habets <errandir_news@mph.eclipse.co.uk>
Subject: PATCH [1/2] - CHECKSTACK: sparc: fix regex to match all stacksize
In-Reply-To: <alpine.LRH.2.00.0911231148441.14263@pub1.ifh.de>
Message-ID: <alpine.LRH.2.00.0911231202440.14263@pub1.ifh.de>
References: <alpine.LRH.2.00.0911231148441.14263@pub1.ifh.de>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Report: ALL_TRUSTED,AWL,BAYES_00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Patrick Boettcher <pboettcher@kernellabs.com>

----
diff --git a/tools/checkstack.pl b/tools/checkstack.pl
index 14ee68e..e0af9c7 100755
--- a/tools/checkstack.pl
+++ b/tools/checkstack.pl
@@ -97,7 +97,7 @@ my (@stack, $re, $dre, $x, $xs);
  		$re = qr/.*[[:space:]]LINK[[:space:]]*(0x$x{1,8})/o;
  	} elsif ($arch eq 'sparc' || $arch eq 'sparc64') {
  		# f0019d10:       9d e3 bf 90     save  %sp, -112, %sp
-		$re = qr/.*save.*%sp, -(([0-9]{2}|[3-9])[0-9]{2}), %sp/o;
+		$re = qr/.*save.*%sp, -(\d*), %sp/o;
  	} else {
  		print("wrong or unknown architecture \"$arch\"\n");
  		exit




