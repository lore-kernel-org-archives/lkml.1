Return-Path: <linux-kernel-owner+w=401wt.eu-S1756349AbZGNVKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349AbZGNVKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 17:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755492AbZGNVKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 17:10:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42073
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755520AbZGNVKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 17:10:16 -0400
Date: Tue, 14 Jul 2009 14:10:20 -0700 (PDT)
Message-Id: <20090714.141020.34896663.davem@davemloft.net>
To: jirislaby@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] NET: sungem, use spin_trylock_irqsave
From: David Miller <davem@davemloft.net>
In-Reply-To: <1247520220-31960-2-git-send-email-jirislaby@gmail.com>
References: <1247520220-31960-1-git-send-email-jirislaby@gmail.com>
	<1247520220-31960-2-git-send-email-jirislaby@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>
Date: Mon, 13 Jul 2009 23:23:40 +0200

> -	if (!spin_trylock(&gp->tx_lock)) {
> +	if (!spin_trylock_irqsave(&gp->tx_lock)) {

I'm about to give you a royal flaming.

Any idea why?

(hint: type 'make' before you send patches!!!!)

