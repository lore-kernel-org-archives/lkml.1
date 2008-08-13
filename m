Return-Path: <linux-kernel-owner+w=401wt.eu-S1755721AbYHMJlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721AbYHMJlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 05:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbYHMJlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 05:41:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54966
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752978AbYHMJk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 05:40:59 -0400
Date: Wed, 13 Aug 2008 02:41:00 -0700 (PDT)
Message-Id: <20080813.024100.169404612.davem@davemloft.net>
To: brunel@diku.dk
Cc: kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
       yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net/rxrpc: Use an IS_ERR test rather than a NULL test
From: David Miller <davem@davemloft.net>
In-Reply-To: <200808081355.21787.brunel@diku.dk>
References: <200808081355.21787.brunel@diku.dk>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julien Brunel <brunel@diku.dk>
Date: Fri, 8 Aug 2008 13:55:21 +0200

> In case of error, the function rxrpc_get_transport returns an ERR
> pointer, but never returns a NULL pointer. So after a call to this
> function, a NULL test should be replaced by an IS_ERR test.
> 
> A simplified version of the semantic patch that makes this change is
> as follows: 
> (http://www.emn.fr/x-info/coccinelle/)
 ...
> Signed-off-by:  Julien Brunel <brunel@diku.dk>
> Signed-off-by:  Julia Lawall <julia@diku.dk>

Applied, thank you.
