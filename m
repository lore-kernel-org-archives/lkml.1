Return-Path: <linux-kernel-owner+w=401wt.eu-S1756525AbXIEFqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbXIEFqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 01:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbXIEFp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 01:45:56 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:23651 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbXIEFpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 01:45:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=Oz+A4fAR7OMyxE8FGt77FKFPtLyMT4lEKeS+BB0uM+P2W8zpqkSwKdA05WdfBrazg1NZbNc8tb4qDIniqDXiQNVNK5ru/b7M9NrdvYlyiV7R27uiFy5ZgHjZmzaY6XzQLixhnTUWB95K8aTIwWdFHsW7qJxvXPn7pGNlYlIuGZ0=
Message-ID: <46DE42D9.2040200@gmail.com>
Date: Wed, 05 Sep 2007 13:47:05 +0800
From: Micah Gruber <micah.gruber@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] Remove unneeded pointer newdp from dccp_v4_request_recv_sock()
 in net/dccp/ipv4.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This trivial patch removes the unneeded pointer newdp, which is never used.

Signed-off-by: Micah Gruber <micah.gruber@gmail.com>
---

--- a/net/dccp/ipv4.c	2007-09-04 23:18:42.000000000 +0800
+++ b/net/dccp/ipv4.c	2007-09-05 00:49:54.000000000 +0800
@@ -381,7 +381,6 @@
 {
 	struct inet_request_sock *ireq;
 	struct inet_sock *newinet;
-	struct dccp_sock *newdp;
 	struct sock *newsk;
 
 	if (sk_acceptq_is_full(sk))
@@ -396,7 +395,6 @@
 
 	sk_setup_caps(newsk, dst);
 
-	newdp		   = dccp_sk(newsk);
 	newinet		   = inet_sk(newsk);
 	ireq		   = inet_rsk(req);
 	newinet->daddr	   = ireq->rmt_addr;

