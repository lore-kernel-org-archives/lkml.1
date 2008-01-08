Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbYAHGez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbYAHGez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 01:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbYAHGeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 01:34:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52261
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751321AbYAHGep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 01:34:45 -0500
Date: Mon, 07 Jan 2008 22:34:43 -0800 (PST)
Message-Id: <20080107.223443.193158042.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: xiyou.wangcong@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [Patch] xfrm_policy_destroy: rename and relative fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080108061516.GD2529@gondor.apana.org.au>
References: <20080103120550.GB2498@hacking>
	<20080108061516.GD2529@gondor.apana.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Tue, 8 Jan 2008 17:15:16 +1100

> On Thu, Jan 03, 2008 at 08:05:50PM +0800, WANG Cong wrote:
> > 
> > Since __xfrm_policy_destroy is used to destory the resources
> > allocated by xfrm_policy_alloc. So using the name
> > __xfrm_policy_destroy is not correspond with xfrm_policy_alloc.
> > Rename it to xfrm_policy_destroy.
> > 
> > And along with some instances that call xfrm_policy_alloc
> > but not using xfrm_policy_destroy to destroy the resource,
> > fix them.
> > 
> > Cc: David Miller <davem@davemloft.net>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> 
> This patch looks OK to me.

Applied, thanks everyone.
