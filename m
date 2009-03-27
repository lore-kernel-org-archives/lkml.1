Return-Path: <linux-kernel-owner+w=401wt.eu-S1753099AbZC0Hip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbZC0Hip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 03:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbZC0Hid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 03:38:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43871
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751857AbZC0Hic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 03:38:32 -0400
Date: Fri, 27 Mar 2009 00:38:19 -0700 (PDT)
Message-Id: <20090327.003819.234492275.davem@davemloft.net>
To: jpirko@redhat.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jgarzik@pobox.com,
       shemminger@linux-foundation.org, bridge@lists.linux-foundation.org,
       fubar@us.ibm.com, bonding-devel@lists.sourceforge.net, kaber@trash.net,
       mschmidt@redhat.com, dada1@cosmosbay.com
Subject: Re: [PATCH] bonding: allow bond in mode balance-alb to work
 properly in bridge -try4
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090326155205.GA28868@psychotron.englab.brq.redhat.com>
References: <20090313183303.GF3436@psychotron.englab.brq.redhat.com>
	<20090326155205.GA28868@psychotron.englab.brq.redhat.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Pirko <jpirko@redhat.com>
Date: Thu, 26 Mar 2009 16:52:06 +0100

> (resend, updated changelog, hook moved into skb_bond_should_drop,
> skb_bond_should_drop ifdefed)
> 
> Hi all.
> 
> The problem is described in following bugzilla:
> https://bugzilla.redhat.com/show_bug.cgi?id=487763
 ...
> This patch solves the situation in the bonding without touching bridge code,
> as Patrick suggested. For every incoming frame to bonding it searches the
> destination address in slaves list and if any of slave addresses matches, it
> rewrites the address in frame by the adress of bonding master. This ensures that
> all frames comming thru the bonding in alb mode have the same address.
> 
> Signed-off-by: Jiri Pirko <jpirko@redhat.com>


I don't like the hook, but if that's how it's best done....

Patrick, please review this.
