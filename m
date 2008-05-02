Return-Path: <linux-kernel-owner+w=401wt.eu-S937534AbYEBXzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937534AbYEBXzN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 19:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764864AbYEBXy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 19:54:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55870
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758419AbYEBXyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 19:54:55 -0400
Date: Fri, 02 May 2008 16:54:55 -0700 (PDT)
Message-Id: <20080502.165455.24687234.davem@davemloft.net>
To: xiyou.wangcong@gmail.com
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org, akpm@osdl.org,
       netdev@vger.kernel.org
Subject: Re: [Patch] (revised) net/xfrm/xfrm_policy.c: replace timer with
 delayed_work
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0805021323470.3349@localhost.localdomain>
References: <alpine.LFD.1.10.0804302355120.2940@localhost.localdomain>
	<20080501011123.GA4060@gondor.apana.org.au>
	<alpine.LFD.1.10.0805021323470.3349@localhost.localdomain>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: WANG Cong <xiyou.wangcong@gmail.com>
Date: Fri, 2 May 2008 13:35:55 +0800 (CST)

> 
> As suggested by Herbert Xu, using workqueue is better than timer
> for net/xfrm/xfrm_policy.c, so replace them with delayed_work.
> And due to this change, we have to disable BH when trying to
> lock.
> 
> Note that, this patch is not fully tested, so should be
> in -mm first.
> 
> Signed-off-by: WANG Cong <wangcong@zeuux.org>

Please let me know when these two patches have gotten some
good testing.
