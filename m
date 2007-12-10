Return-Path: <linux-kernel-owner+w=401wt.eu-S1757105AbXLJSDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105AbXLJSDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 13:03:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756882AbXLJSDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 13:03:22 -0500
Received: from [198.99.130.12] ([198.99.130.12]:55220 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756755AbXLJSDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 13:03:21 -0500
Date: Mon, 10 Dec 2007 13:03:09 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Julia Lawall <julia@diku.dk>
Cc: wangchen@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/3] Fix use of skb after netif_rx
Message-ID: <20071210180309.GA9068@c2.user-mode-linux.org>
References: <Pine.LNX.4.64.0712092101160.11165@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712092101160.11165@ask.diku.dk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 09, 2007 at 09:02:31PM +0100, Julia Lawall wrote:
> Recently, Wang Chen submitted a patch
> (d30f53aeb31d453a5230f526bea592af07944564) to move a call to netif_rx(skb)
> after a subsequent reference to skb, because netif_rx may call kfree_skb on
> its argument.  The same problem occurs in some other drivers as well.
> 
> This was found using the following semantic match.
> (http://www.emn.fr/x-info/coccinelle/)

Thanks, I'll forward this on.

			Jeff

-- 
Work email - jdike at linux dot intel dot com
