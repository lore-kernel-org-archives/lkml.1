Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbZKZXPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbZKZXPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 18:15:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752933AbZKZXPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 18:15:45 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:43062 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbZKZXPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 18:15:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Hvs5rL2zJfLQopn1uxHYYt9XAYQ7sKPiXFyS3phZxDqP0+9DKZO+FGxwuE8B6RVA3U
         nYxFAFMXgeAddob2DzbfUeSUCJchqAiApGGh/Usw8Et0wxtz9AxOhVzoNAotdxLsaJQy
         c1keVX4ZiAbL1Cfsw9o+Fvtc3w139vw2N2xzY=
Date: Thu, 26 Nov 2009 20:13:42 -0300
From: Rudy Matela <rudy.matela@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] Coding style correction in HDLC/Frame Relay support
 routines
Message-ID: <20091126231342.GA25041@vacuum.larces.uece.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coding style corrections on Frame Relay/DLCI support routines.

Added a space separating some if keywords from the following parenthesis to
conform to the CodingStyle.

Signed-off-by: Rudy Matela <rudy.matela@gmail.com>
---

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 840cff7..a7d4fc1 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -1214,10 +1214,10 @@ static int fr_ioctl(struct net_device *dev, struct ifreq *ifr)
 		return 0;
 
 	case IF_PROTO_FR:
-		if(!capable(CAP_NET_ADMIN))
+		if (!capable(CAP_NET_ADMIN))
 			return -EPERM;
 
-		if(dev->flags & IFF_UP)
+		if (dev->flags & IFF_UP)
 			return -EBUSY;
 
 		if (copy_from_user(&new_settings, fr_s, size))
@@ -1263,7 +1263,7 @@ static int fr_ioctl(struct net_device *dev, struct ifreq *ifr)
 		if (dev_to_hdlc(dev)->proto != &proto) /* Different proto */
 			return -EINVAL;
 
-		if(!capable(CAP_NET_ADMIN))
+		if (!capable(CAP_NET_ADMIN))
 			return -EPERM;
 
 		if (copy_from_user(&pvc, ifr->ifr_settings.ifs_ifsu.fr_pvc,
