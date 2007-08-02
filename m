Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbXHBJYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbXHBJYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 05:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755505AbXHBJXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 05:23:44 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:3407 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445AbXHBJXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 05:23:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=lGbjPsww/j7OX0rtNnkBgGCcedNdfPf3SrOSUkUVxC6TwCO7Rf0on7GwAg+Y1OWtmq2apC6j5siayeX8bp7KiLilXb+7meZ8nn/EI3yQCnIolvSfrKCdD8Hq68Mr1ljIjFXat/uQZN6IKV4tNbgNUey7AsheDCZymE7Ww2P63UM=
Message-ID: <eb3ff54b0708020223o521e89b9v3200e06ab296df12@mail.gmail.com>
Date: Thu, 2 Aug 2007 12:23:41 +0300
From: "Rami Rosen" <ramirose@gmail.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] Removal of FASTROUTE definition include/linux/if_packet.h
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  It seems that PACKET_FASTROUTE definition should be removed due to that
	fastroute is no longer supported.

Regards,
Rami Rosen
--


Signed-off-by: Rami Rosen <ramirose@gmail.com>
	
	
--- linux-2.6.23-rc1-clean/include/linux/if_packet.h	2007-05-03
12:07:59.000000000 +0300
+++ linux-2.6.23-rc1/include/linux/if_packet.h	2007-08-02
11:37:16.000000000 +0300
@@ -30,7 +30,6 @@ struct sockaddr_ll
 #define PACKET_OUTGOING		4		/* Outgoing of any type */
 /* These ones are invisible by user level */
 #define PACKET_LOOPBACK		5		/* MC/BRD frame looped back */
-#define PACKET_FASTROUTE	6		/* Fastrouted frame	*/

 /* Packet socket options */
