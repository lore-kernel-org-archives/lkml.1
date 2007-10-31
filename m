Return-Path: <linux-kernel-owner+w=401wt.eu-S1753342AbXJaDlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbXJaDlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 23:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbXJaDlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 23:41:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45288
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752481AbXJaDlK (ORCPT
	<rfc822;Linux-Kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 23:41:10 -0400
Date: Tue, 30 Oct 2007 20:41:10 -0700 (PDT)
Message-Id: <20071030.204110.216540107.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: Joel.Becker@oracle.com, netdev@vger.kernel.org,
       Linux-Kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: dev_ifname32() fails on 32->64bit calls in copy_in_user().
From: David Miller <davem@davemloft.net>
In-Reply-To: <1193798124.9928.91.camel@pasglop>
References: <20071031003850.GE7517@tasint.org>
	<1193798124.9928.91.camel@pasglop>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Wed, 31 Oct 2007 13:35:24 +1100

> [PATCH] Fix new dev_ifname32 returning -EFAULT
> 
> A stray semicolon slipped in the patch that updated dev_ifname32 to
> not be inline, causing it to always return -EFAULT. This fixes it.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Applied, thanks for the fix Ben!
