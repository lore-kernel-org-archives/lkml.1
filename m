Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478AbZDMWya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbZDMWya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 18:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbZDMWyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 18:54:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43340
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752437AbZDMWyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 18:54:16 -0400
Date: Mon, 13 Apr 2009 15:54:07 -0700 (PDT)
Message-Id: <20090413.155407.12944222.davem@davemloft.net>
To: jpirko@redhat.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jgarzik@pobox.com,
       shemminger@linux-foundation.org, bridge@lists.linux-foundation.org,
       fubar@us.ibm.com, bonding-devel@lists.sourceforge.net, kaber@trash.net,
       mschmidt@redhat.com, dada1@cosmosbay.com, ivecera@redhat.com
Subject: Re: [PATCH 3/4] net: bridge: use device address list instead of
 dev_addr
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090413084407.GD23734@psychotron.englab.brq.redhat.com>
References: <20090313183303.GF3436@psychotron.englab.brq.redhat.com>
	<20090413083729.GA23734@psychotron.englab.brq.redhat.com>
	<20090413084407.GD23734@psychotron.englab.brq.redhat.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Pirko <jpirko@redhat.com>
Date: Mon, 13 Apr 2009 10:44:08 +0200

> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> index a48f5ef..6efc556 100644
> --- a/net/bridge/br_fdb.c
> +++ b/net/bridge/br_fdb.c
 ...
> +static inline int is_dev_addr(struct net_device *dev, unsigned char *addr)
> +{

Please drop the inline, let the compiler work it out.
