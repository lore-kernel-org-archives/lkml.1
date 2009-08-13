Return-Path: <linux-kernel-owner+w=401wt.eu-S1751399AbZHMES6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbZHMES6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 00:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbZHMES5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 00:18:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43274
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751036AbZHMES4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 00:18:56 -0400
Date: Wed, 12 Aug 2009 21:19:07 -0700 (PDT)
Message-Id: <20090812.211907.124112530.davem@davemloft.net>
To: julia@diku.dk
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drivers/net/tokenring: Use status field rather than
 state field
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0908080846000.25176@ask.diku.dk>
References: <Pine.LNX.4.64.0908080846000.25176@ask.diku.dk>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Sat, 8 Aug 2009 08:47:33 +0200 (CEST)

> From: Julia Lawall <julia@diku.dk>
> 
> In general in this file, it is the status field, not the state field, that
> contains values like OPEN and CLOSED.  Indeed, in the first error case, it
> is the field status that is initialized.  I have thus assumed that all of
> the error handling code should be the same, and moved it to the end of the
> function to emphasize its commonality.
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied.
