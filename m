Return-Path: <linux-kernel-owner+w=401wt.eu-S932929AbYGQVpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929AbYGQVpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 17:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759047AbYGQVpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 17:45:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41466
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757273AbYGQVpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 17:45:05 -0400
Date: Thu, 17 Jul 2008 14:45:04 -0700 (PDT)
Message-Id: <20080717.144504.96425101.davem@davemloft.net>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, rjw@sisk.pl
Subject: Re: [bug, netconsole, SLUB] BUG skbuff_head_cache: Poison
 overwritten
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080717214222.GA29449@elte.hu>
References: <20080717214222.GA29449@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 17 Jul 2008 23:42:22 +0200

> 
> A regression to v2.6.26:
> 
> I started getting this skb-head corruption message today, on a T60 
> laptop with e1000:

This is very unlikely to be added by us networking folks, no
networking merges have happened for the 2.6.27 merge window yet :-)
