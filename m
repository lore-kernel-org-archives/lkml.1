Return-Path: <linux-kernel-owner+w=401wt.eu-S933008AbXA2AEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008AbXA2AEo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 19:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933007AbXA2AEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 19:04:44 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54825
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933001AbXA2AEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 19:04:43 -0500
Date: Sun, 28 Jan 2007 16:04:42 -0800 (PST)
Message-Id: <20070128.160442.48527586.davem@davemloft.net>
To: bunk@stusta.de
Cc: randy.dunlap@oracle.com, akpm@osdl.org, linux-kernel@vger.kernel.org,
       netfilter@lists.netfilter.org, netdev@vger.kernel.org, kaber@trash.net
Subject: Re: [2.6 patch] NF_CONNTRACK_H323 must depend on (IPV6 || IPV6=n)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070129000011.GB6017@stusta.de>
References: <20070128222136.GZ6017@stusta.de>
	<20070128.155348.39160134.davem@davemloft.net>
	<20070129000011.GB6017@stusta.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@stusta.de>
Date: Mon, 29 Jan 2007 01:00:11 +0100

> On Sun, Jan 28, 2007 at 03:53:48PM -0800, David Miller wrote:
> > Adrian is this the correct way to constrain the selection between
> > "n" and "m" in this kind of situation?  I thought doing something
> > like "depends on IPV6" is sufficient to achieve that?
> 
> "depends on IPV6" would fix the bug - but it would also make 
> NF_CONNTRACK_H323 unavailable for all people without IPV6 support in 
> their kernel.

Yes, that is an issue.

I guess with some slightly ugly ifdefs we could support the
whole matrix of possibilities.  But perhaps that's undesirable
for another reason.

Patrick?
