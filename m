Return-Path: <linux-kernel-owner+w=401wt.eu-S1756644AbYEDBh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbYEDBh6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 21:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbYEDBhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 21:37:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44331
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752027AbYEDBhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 21:37:46 -0400
Date: Sat, 03 May 2008 18:37:46 -0700 (PDT)
Message-Id: <20080503.183746.01223933.davem@davemloft.net>
To: xiyou.wangcong@gmail.com
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org, akpm@osdl.org,
       netdev@vger.kernel.org
Subject: Re: [Patch] (revised) net/xfrm/xfrm_policy.c: replace timer with
 delayed_work
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080503144647.GF3986@hack>
References: <alpine.LFD.1.10.0805021323470.3349@localhost.localdomain>
	<20080502.165455.24687234.davem@davemloft.net>
	<20080503144647.GF3986@hack>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: WANG Cong <xiyou.wangcong@gmail.com>
Date: Sat, 3 May 2008 22:46:49 +0800

> I thought it can go into -mm so that many other people can help
> me to test it. Since I didn't have the IPSec environment. ;(

You don't need an "IPSEC environment" (whatever that is) to test these
code paths.

It's very easy to setup simplistic IPSEC states and policies between
two computers using "setkey" and friends.
