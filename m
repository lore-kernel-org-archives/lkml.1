Return-Path: <linux-kernel-owner+w=401wt.eu-S1755412AbZFDDBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbZFDDBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 23:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbZFDDAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 23:00:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33755
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751237AbZFDDAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 23:00:50 -0400
Date: Wed, 03 Jun 2009 20:00:50 -0700 (PDT)
Message-Id: <20090603.200050.146284422.davem@davemloft.net>
To: divy@chelsio.com
Cc: ben@decadent.org.uk, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH net-next 2/2] cxgb3: Add Aeluros 2020 phy support
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A27311D.7070400@chelsio.com>
References: <20090529075829.30669.41488.stgit@speedy5>
	<20090601105349.GF3051@decadent.org.uk>
	<4A27311D.7070400@chelsio.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Wed, 03 Jun 2009 19:27:41 -0700

> In a boot over the network environment, request_firmware() will not be
> granted
> access to the file system.

This is not true, first of all.  It can be built into the kernel image
via CONFIG_FIRMWARE_IN_KERNEL.

Second of all, there is initrd.

There are NO EXCUSES for not using request_firmware() at this point.
