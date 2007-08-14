Return-Path: <linux-kernel-owner+w=401wt.eu-S935134AbXHNFGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935134AbXHNFGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 01:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765773AbXHNFFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 01:05:46 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36177 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765298AbXHNFFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 01:05:43 -0400
Message-ID: <46C13822.7040803@pobox.com>
Date: Tue, 14 Aug 2007 01:05:38 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
CC: Arjan van de Ven <arjan@infradead.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/tulip/xircom_cb.c: remove superfulous priv assignment
References: <200708081320.26756.m.kozlowski@tuxland.pl>
In-Reply-To: <200708081320.26756.m.kozlowski@tuxland.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mariusz Kozlowski wrote:
> Hello,
> 
> 	Unpatched version does sth like this:
> 
> dev = alloc_etherdev(...
> private = netdev_priv(dev);
> ...
> dev->priv = private;
> 
> which doesn't make much sense (does it?) because this is done in
> alloc_netdev() already.
> 
> struct net_device *alloc_netdev(...
> {
> ...
> 	if (sizeof_priv)
> 		dev->priv = netdev_priv(dev);
> 
> This patch removes superfluous code.
> 
> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

applied


