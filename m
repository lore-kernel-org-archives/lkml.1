Return-Path: <linux-kernel-owner+w=401wt.eu-S1761980AbYEVIHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761980AbYEVIHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 04:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933772AbYEVIGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 04:06:38 -0400
Received: from proxy.ovh.net ([213.186.50.98]:51360 "EHLO proxy.ovh.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933435AbYEVIGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 04:06:33 -0400
Message-ID: <483529FA.4030305@ovh.net>
Date: Thu, 22 May 2008 10:08:26 +0200
From: Emmanuel Colbus <emmanuel.colbus@ovh.net>
User-Agent: Icedove 1.5.0.14eol (X11/20080509)
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][TRIVIAL] r8169.c : fix misleading comment
References: <48342CDF.1040304@ovh.net> <20080521185306.GA9320@electric-eye.fr.zoreil.com>
In-Reply-To: <20080521185306.GA9320@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu wrote:
> Emmanuel Colbus <emmanuel.colbus@ovh.net> :
>   
>> Calling "PCI base addr 1" something that can actually lie at 
>> PCI_BASE_ADDR_2 is misleading. Patch follows.
>>
>> signed-off-by : emmanuel colbus <emmanuel.colbus@ovh.net>
>>     
>
> I do not approve:
> - the patch does not follow the comment style of the driver
> - the comment should be removed, not silly augmented
>
>   
OK, makes sense. Second version :



This comment is misleading, since the region it refers to can actually 
be PCI_BASE_ADDR_2. Remove it.

signed-off-by : emmanuel colbus <emmanuel.colbus@ovh.net>
---

diff -Naur drivers/net/r8169.c.old drivers/net/r8169.c
--- drivers/net/r8169.c.old     2008-05-22 09:55:51.000000000 +0200
+++ drivers/net/r8169.c 2008-05-22 09:55:59.000000000 +0200
@@ -1632,7 +1632,6 @@
        if (rc < 0)
                goto err_out_disable_2;
 
-       /* make sure PCI base addr 1 is MMIO */
        if (!(pci_resource_flags(pdev, region) & IORESOURCE_MEM)) {
                if (netif_msg_probe(tp)) {
                        dev_err(&pdev->dev,

