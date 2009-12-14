Return-Path: <linux-kernel-owner+w=401wt.eu-S1756584AbZLND5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584AbZLND5b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 22:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756569AbZLND52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 22:57:28 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34140
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756567AbZLND51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 22:57:27 -0500
Date: Sun, 13 Dec 2009 19:57:29 -0800 (PST)
Message-Id: <20091213.195729.28793749.davem@davemloft.net>
To: julia@diku.dk
Cc: linux-net-drivers@solarflare.com, shodgson@solarflare.com,
       bhutchings@solarflare.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/9] drivers/net/sfc: Correct code taking the size of a
 pointer
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0912131241130.24267@ask.diku.dk>
References: <Pine.LNX.4.64.0912131241130.24267@ask.diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Sun, 13 Dec 2009 12:41:29 +0100 (CET)

> From: Julia Lawall <julia@diku.dk>
> 
> The function efx_iterate_state contains the code
> memcpy(&payload->msg, payload_msg, sizeof(payload_msg));
> This is the only use of payload_msg.  The type of payload_msg is
> changed from a pointer to an array, so that the result of sizeof really is
> the length of the string.
> 
> A simplified version of the semantic patch that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied.
