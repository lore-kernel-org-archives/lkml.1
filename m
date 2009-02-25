Return-Path: <linux-kernel-owner+w=401wt.eu-S1762495AbZBYWAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762495AbZBYWAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 17:00:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759191AbZBYV77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 16:59:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39361
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756590AbZBYV76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 16:59:58 -0500
Date: Wed, 25 Feb 2009 13:59:41 -0800 (PST)
Message-Id: <20090225.135941.33443374.davem@davemloft.net>
To: Geert.Uytterhoeven@sonycom.com
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/6] netlink: Move netlink attribute parsing support to
 lib/
From: David Miller <davem@davemloft.net>
In-Reply-To: <1235569394-15217-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
References: <1235569394-15217-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
	<1235569394-15217-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Date: Wed, 25 Feb 2009 14:43:09 +0100

> Netlink attribute parsing may be used even if CONFIG_NET is not set.
> Move it from net/netlink to lib and control its inclusion based on the new
> config symbol CONFIG_NLATTR, which is selected by CONFIG_NET.
> 
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Acked-by: David S. Miller <davem@davemloft.net>
