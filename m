Return-Path: <linux-kernel-owner+w=401wt.eu-S1753762AbXJaDmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbXJaDmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 23:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbXJaDmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 23:42:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45294
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751944AbXJaDmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 23:42:12 -0400
Date: Tue, 30 Oct 2007 20:42:12 -0700 (PDT)
Message-Id: <20071030.204212.165284311.davem@davemloft.net>
To: spock@gentoo.org
Cc: linux-kernel@vger.kernel.org, den@openvz.org, dex@dragonslave.de,
       johnpol@2ka.mipt.ru
Subject: Re: [PATCH] Fix a spurious kfree_skb() call
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071030231051.GA3636@spock.one.pl>
References: <20071030231051.GA3636@spock.one.pl>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Januszewski <spock@gentoo.org>
Date: Wed, 31 Oct 2007 00:10:52 +0100

> Remove a spurious call to kfree_skb() in the connector rx_skb handler.
> 
> This fixes a regression introduced by the '[NET]: make netlink user ->
> kernel interface synchronious' patch (cd40b7d3983c708aabe3d3008ec64ffce56d33b0)
> 
> Signed-off-by: Michal Januszewski <spock@gentoo.org>

Applied, thanks!
