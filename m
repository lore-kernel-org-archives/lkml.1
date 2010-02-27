Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966820Ab0B0MEr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 07:04:47 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48850
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966434Ab0B0MEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 07:04:45 -0500
Date: Sat, 27 Feb 2010 04:05:02 -0800 (PST)
Message-Id: <20100227.040502.182574085.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: hancockrwd@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [RFC PATCH] fix problems with NETIF_F_HIGHDMA in networking
 drivers
From: David Miller <davem@davemloft.net>
In-Reply-To: <201002271259.31596.bzolnier@gmail.com>
References: <51f3faa71002261908y7cfa62eeicb3e56d5c920887a@mail.gmail.com>
	<20100227.015350.71138134.davem@davemloft.net>
	<201002271259.31596.bzolnier@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Sat, 27 Feb 2010 12:59:31 +0100

> Having IOMMU (even if it is only a software one, i.e. this would
> mean swiotlb for x86-32/highmem) always in place would simplify
> things greatly..

I agree, things would be a lot simpler.
