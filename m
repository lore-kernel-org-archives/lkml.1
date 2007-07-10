Return-Path: <linux-kernel-owner+w=401wt.eu-S1761585AbXGJQqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761585AbXGJQqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 12:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754437AbXGJQp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 12:45:59 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60249 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754303AbXGJQp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 12:45:58 -0400
Message-ID: <4693B7C3.7090507@garzik.org>
Date: Tue, 10 Jul 2007 12:45:55 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2,6 patch] sunhme.c:quattro_pci_find() must be __devinit
References: <20070710124449.GZ3492@stusta.de>
In-Reply-To: <20070710124449.GZ3492@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch fixes the following section mismatch:
> 
> <--  snip  -->
> 
> ...
>   MODPOST vmlinux
> WARNING: drivers/built-in.o(.text+0x272f8b): Section mismatch: reference to .init.text:quattro_pci_find (between 'happy_meal_pci_probe' and 'happy_meal_pci_remove')
> ...
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

applied


