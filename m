Return-Path: <linux-kernel-owner+w=401wt.eu-S1756234AbXKAVfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbXKAVfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 17:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbXKAVfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 17:35:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50908
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752700AbXKAVfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 17:35:36 -0400
Date: Thu, 01 Nov 2007 14:35:35 -0700 (PDT)
Message-Id: <20071101.143535.45402283.davem@davemloft.net>
To: greearb@candelatech.com
Cc: shemminger@linux-foundation.org,
       djohnson+linux-kernel@sw.starentnetworks.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       bguo@sw.starentnetworks.com
Subject: Re: expected behavior of PF_PACKET on NETIF_F_HW_VLAN_RX device?
From: David Miller <davem@davemloft.net>
In-Reply-To: <4729EAFF.9050606@candelatech.com>
References: <47292A99.5070805@linux-foundation.org>
	<20071031.215025.195350296.davem@davemloft.net>
	<4729EAFF.9050606@candelatech.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>
Date: Thu, 01 Nov 2007 08:04:31 -0700

> David Miller wrote:
> > The hardware has stripped the VLAN header completely and has not
> > provided it to us at all.
> >   
> Do the NICs not save the QoS bits in the VLAN header anywhere that we could
> use to reconstitute the header?

You get the 16-bit VLAN tag.
