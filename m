Return-Path: <linux-kernel-owner+w=401wt.eu-S1757985AbYDJSV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985AbYDJSV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 14:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757309AbYDJSVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 14:21:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:6657 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757305AbYDJSVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 14:21:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=RpyEeWVsVlqOp7FjqHCef4kwAQ6EJok0kk01DwjfMkuLlzndvnqM+z1Z8PGloYz+j+J6O2BAm+j6wZwfDMm0FEf8FQywDT2j41UQaIV5NZwKcZBsMdJLiXAy2BYmOcJ7RNolbNNCsNKpiiuoBbpJMZQJH9d+F7EUOIwLvtM0YKI=
Message-ID: <eb3ff54b0804101121lf741824xb875cf49a2629cc6@mail.gmail.com>
Date: Thu, 10 Apr 2008 21:21:12 +0300
From: "Rami Rosen" <ramirose@gmail.com>
To: "David Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH] [net-2.6.26] [IPV6] Add stats in multicast routing module method ip6_mr_forward().
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_13515_17153263.1207851672898"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_13515_17153263.1207851672898
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
  This patches adds a call to increment IPSTATS_MIB_OUTFORWDATAGRAMS
   when forwarding the packet in ip6_mr_forward() in the IPv6
multicast routing module (net/ipv6/ip6mr.c).
	

Regards,
Rami Rosen


Signed-off-by: Rami Rosen <ramirose@gmail.com>

------=_Part_13515_17153263.1207851672898
Content-Type: text/plain; name=patch.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fevmrmuv0
Content-Disposition: attachment; filename=patch.txt

ZGlmZiAtLWdpdCBhL25ldC9pcHY2L2lwNm1yLmMgYi9uZXQvaXB2Ni9pcDZtci5jCmluZGV4IGRh
NjczZWYuLmUzYWM2MDYgMTAwNjQ0Ci0tLSBhL25ldC9pcHY2L2lwNm1yLmMKKysrIGIvbmV0L2lw
djYvaXA2bXIuYwpAQCAtMTM2OCw3ICsxMzY4LDcgQEAgaW50IGlwNm1yX2lvY3RsKHN0cnVjdCBz
b2NrICpzaywgaW50IGNtZCwgdm9pZCBfX3VzZXIgKmFyZykKIAogc3RhdGljIGlubGluZSBpbnQg
aXA2bXJfZm9yd2FyZDJfZmluaXNoKHN0cnVjdCBza19idWZmICpza2IpCiB7Ci0JLyogWFhYIHN0
YXRzICovCisJSVA2X0lOQ19TVEFUU19CSChpcDZfZHN0X2lkZXYoc2tiLT5kc3QpLCBJUFNUQVRT
X01JQl9PVVRGT1JXREFUQUdSQU1TKTsKIAlyZXR1cm4gZHN0X291dHB1dChza2IpOwogfQogCg==

------=_Part_13515_17153263.1207851672898--
