Return-Path: <linux-kernel-owner+w=401wt.eu-S1760275AbYDOH37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275AbYDOH37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 03:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754515AbYDOH3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 03:29:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41570
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752766AbYDOH3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 03:29:45 -0400
Date: Tue, 15 Apr 2008 00:29:47 -0700 (PDT)
Message-Id: <20080415.002947.78850803.davem@davemloft.net>
To: bunk@kernel.org
Cc: samuel@sortiz.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       rpjday@crashcourse.ca
Subject: Re: [RFC: 2.6 patch] remove irlan_eth_send_gratuitous_arp()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080414184053.GH6695@cs181133002.pp.htv.fi>
References: <20080414184053.GH6695@cs181133002.pp.htv.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Mon, 14 Apr 2008 21:40:53 +0300

> Even kernel 2.2.26 (sic) already contains the
>   #undef CONFIG_IRLAN_SEND_GRATUITOUS_ARP
> with the comment "but for some reason the machine crashes if you use DHCP".
> 
> Either someone finally looks into this or it's simply time to remove 
> this dead code.
> 
> Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

I think that's old enough cruft that we can indeed just kill this off.

Applied, thanks Adrian.
