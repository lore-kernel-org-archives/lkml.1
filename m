Return-Path: <linux-kernel-owner+w=401wt.eu-S1751799AbZKFFHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799AbZKFFHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 00:07:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbZKFFHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 00:07:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52485
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751702AbZKFFHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 00:07:45 -0500
Date: Thu, 05 Nov 2009 21:08:10 -0800 (PST)
Message-Id: <20091105.210810.124818005.davem@davemloft.net>
To: ghaskins@novell.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] net: add dataref destructor to sk_buff
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091002141407.30224.54207.stgit@dev.haskins.net>
References: <20091002141407.30224.54207.stgit@dev.haskins.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregory Haskins <ghaskins@novell.com>
Date: Fri, 02 Oct 2009 10:20:00 -0400

> The following is an RFC for an attempt at addressing a zero-copy solution.
> 
> To be perfectly honest, I have no idea if this is the best solution, or if
> there is truly a problem with skb->destructor that requires an alternate
> mechanism.  What I do know is that this patch seems to work, and I would
> like to see some kind of solution available upstream.  So I thought I would
> send my hack out as at least a point of discussion.  FWIW: This has been
> tested heavily in my rig and is technically suitable for inclusion after
> review as is, if that is decided to be the optimal path forward here.
> 
> Thanks for your review and consideration,

I have no fundamental objections, but when you submit this for
real can you show the code that uses it so we can get a better
idea about things?

Thanks.
