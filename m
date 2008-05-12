Return-Path: <linux-kernel-owner+w=401wt.eu-S1756862AbYELWoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbYELWoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 18:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755384AbYELWoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 18:44:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35841
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755030AbYELWoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 18:44:09 -0400
Date: Mon, 12 May 2008 15:44:04 -0700 (PDT)
Message-Id: <20080512.154404.127453165.davem@davemloft.net>
To: julia@diku.dk
Cc: netdev@vger.kernel.org, jchapman@katalix.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 6/6, revised] drivers/net/pppol2tp.c: remove null
 pointer dereference
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0805122220350.27663@ask.diku.dk>
References: <Pine.LNX.4.64.0805122220350.27663@ask.diku.dk>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Mon, 12 May 2008 22:21:25 +0200 (CEST)

> If session is NULL, it is not possible to access its name field.  So I have
> split apart the printing of the error message to drop the printing of the
> name field in this case.
> 
> The macro PRINTK actually only evaluates its arguments starting with the
> third one if the bitwise conjunction of the first two is non-zero.
> Normally, this conjunction would only be non-zero if debugging mode were
> turned on, but when session is NULL, the first argument in both the old and
> new code is -1, and thus the bitwise conjunction is true.  Perhaps a
> different strategy is desired, such as using tunnel->debug, which
> session->debug is initialized to, but tunnel can also be NULL, so this does
> not completely solve the problem.
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied, thanks.
