Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbYKLURR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbYKLURR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 15:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbYKLURB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 15:17:01 -0500
Received: from rn-out-0910.google.com ([64.233.170.188]:62115 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbYKLURA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 15:17:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=ew+UlJNZrbOnsU2bQGZTtw8/oeao9Mqw9P7l18HzP5pI1GyAaekNvrmrjLCIfdQ1Ns
         /z/is7ZuwDfvVizNpPTaUIFKGI75v2HCZjTJz1FPhkmD7GbVgf/q8Wl/KVmp+pvEAdSj
         y1F5H/yyDUpkRxEYi5nPFAFb7SCXpuGHF5Gh8=
Message-ID: <a1820cc70811121216o45435bdfs221415c9c960d276@mail.gmail.com>
Date: Wed, 12 Nov 2008 20:16:59 +0000
From: "Bob Jolliffe" <bobjolliffe@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] rtl8187 : support for Sitecom WL-168 0001 v4
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
the Sitecom 0001 v4 with product id 0x0df6:0028, uses Realtek's
RTL8187B and work fine
with new 2.6.27 driver. Please consider to add support of this card.

*** linux-2.6.27/drivers/net/wireless/rtl8187_dev.c	2008-10-09
23:13:53.000000000 +0100
--- linux-source-2.6.27/drivers/net/wireless/rtl8187_dev.c	2008-11-12
14:39:18.000000000 +0000
***************
*** 45,50 ****
--- 45,51 ----
  	{USB_DEVICE(0x03f0, 0xca02), .driver_info = DEVICE_RTL8187},
  	/* Sitecom */
  	{USB_DEVICE(0x0df6, 0x000d), .driver_info = DEVICE_RTL8187},
+ 	{USB_DEVICE(0x0df6, 0x0028), .driver_info = DEVICE_RTL8187B},
  	{}
  };


-- 
Bob Jolliffe
