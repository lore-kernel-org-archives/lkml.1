Return-Path: <linux-kernel-owner+w=401wt.eu-S1757935AbYDRGVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935AbYDRGVB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 02:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbYDRGUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 02:20:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56029
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753372AbYDRGUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 02:20:47 -0400
Date: Thu, 17 Apr 2008 23:20:47 -0700 (PDT)
Message-Id: <20080417.232047.27944044.davem@davemloft.net>
To: mchan@broadcom.com
Cc: tonyb@cybernetics.com, mcarlson@broadcom.com, herbert@gondor.apana.org.au,
       netdev@vger.kernel.org, gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: TG3 network data corruption regression 2.6.24/2.6.23.4
From: David Miller <davem@davemloft.net>
In-Reply-To: <1551EAE59135BE47B544934E30FC4FC002AABC73@nt-irva-0751.brcm.ad.broadcom.com>
References: <20080415.203108.55491723.davem@davemloft.net>
	<1551EAE59135BE47B544934E30FC4FC002AABC73@nt-irva-0751.brcm.ad.broadcom.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael Chan" <mchan@broadcom.com>
Date: Wed, 16 Apr 2008 08:40:25 -0700

> Isn't it better to test for skb->data?  That's where we tell
> the hardware to start transmitting.

That's correct.
