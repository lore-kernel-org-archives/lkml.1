Return-Path: <linux-kernel-owner+w=401wt.eu-S1760592AbXHOVqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760592AbXHOVqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 17:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755319AbXHOVqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 17:46:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45840
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755443AbXHOVqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 17:46:35 -0400
Date: Wed, 15 Aug 2007 14:46:28 -0700 (PDT)
Message-Id: <20070815.144628.104052147.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: 123.oleg@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux kernel 2.6.18-20 bug: rcu_read_unlock in __sock_create
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1ILEJr-0005Fl-00@gondolin.me.apana.org.au>
References: <af57f1ac0708141130v729fa636k3150673809ec20a8@mail.gmail.com>
	<E1ILEJr-0005Fl-00@gondolin.me.apana.org.au>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Wed, 15 Aug 2007 16:33:35 +0800

> [NET]: Fix unbalanced rcu_read_unlock in __sock_create
> 
> The recent RCU work created an unbalanced rcu_read_unlock
> in __sock_create.  This patch fixes that.  Reported by
> oleg 123.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Patch applied, thanks Herbert.
