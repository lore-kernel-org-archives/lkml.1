Return-Path: <linux-kernel-owner+w=401wt.eu-S934605AbXGaUkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934605AbXGaUkU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 16:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934138AbXGaUhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 16:37:10 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:31748 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934389AbXGaUhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 16:37:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=B1MeKIGEaTpj07YY0hb1eRe+IW2h4S7X7dtp0unuLPENRwokljcXk0QOV6yc1puMoAa0wjCIg3r1SJI6pqh1Z9QjG+RXC9asz62hIhDBTM6g+XKc9xzizIh8kL6LCseoFtXENgULX7elYNN7XlwFzTpG80VzpXHZ9A86x8Lr/hs=
Message-ID: <46AF9D5B.7010607@googlemail.com>
Date: Tue, 31 Jul 2007 22:36:43 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       "Netdev" <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] Get rid of dead code in net/ipv4/fib_semantics.c
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

File /home/devel/linux-rdc/net/ipv4/fib_semantics.c line 525
Unknown CONFIG option! CONFIG_IP_ROUTE_PERVASIVE

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-rdc-clean/net/ipv4/fib_semantics.c	2007-07-31 17:17:31.000000000 +0200
+++ linux-rdc/net/ipv4/fib_semantics.c	2007-07-31 18:22:54.000000000 +0200
@@ -522,10 +522,6 @@ static int fib_check_nh(struct fib_confi
 	if (nh->nh_gw) {
 		struct fib_result res;
 
-#ifdef CONFIG_IP_ROUTE_PERVASIVE
-		if (nh->nh_flags&RTNH_F_PERVASIVE)
-			return 0;
-#endif
 		if (nh->nh_flags&RTNH_F_ONLINK) {
 			struct net_device *dev;
 
