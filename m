Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbZBSHcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbZBSHcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 02:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbZBSHcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 02:32:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54281
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752570AbZBSHcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 02:32:02 -0500
Date: Wed, 18 Feb 2009 23:31:45 -0800 (PST)
Message-Id: <20090218.233145.66997963.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: kaber@trash.net, karl@hiramoto.org, netdev@vger.kernel.org,
       netfilter@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Re: problem with IPoA (CLIP), NAT, and VLANS
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090217093908.GB5341@ff.dom.local>
References: <20090216232016.GA4803@ami.dom.local>
	<499A7D7D.1090607@trash.net>
	<20090217093908.GB5341@ff.dom.local>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Tue, 17 Feb 2009 09:39:08 +0000

> vlan: Update skb->mac_header in __vlan_put_tag().
> 
> After moving mac addresses in __vlan_put_tag() skb->mac_header needs
> to be updated.
> 
> Reported-by: Karl Hiramoto <karl@hiramoto.org>
> Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>

Patch applied, this is correct even though it doesn't fix the bug.

I'm pretty sure that packet corruption is a driver error of
some kind rather than some kind of generic problem.
