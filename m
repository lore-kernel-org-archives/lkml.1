Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbXKVX3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbXKVX3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 18:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbXKVX3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 18:29:21 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:59407 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbXKVX3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 18:29:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=sK50QhyEACBNS33fjDe9fFSCesViK7u/dTan08wEP62mO/tbUyL1aA9nOtUr45nTV7i3oXiLDgrFaXp8BBK6oE6dhn2t+Qcn0BmqhpEaikPmuHbViEjGeLgsluJQBUgHFOhnN60xhVlWdLOEcpToIAh934mjRjAYz0jZE7hpK3M=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Linux Netdev List <netdev@vger.kernel.org>
Subject: NET: dmfe.c : fix access to card's pci config space in D3
Date: Fri, 23 Nov 2007 01:29:02 +0200
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711230129.02570.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I somehow assumed that pci_save_state should be called while 
device is powered off, but actually the opposite is true.

Thus I am sending this patch to fix it.

Sorry for this mistake,
	Best regards,
		Maxim Levitsky

