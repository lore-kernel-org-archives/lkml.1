Return-Path: <linux-kernel-owner+w=401wt.eu-S1759392AbXKLWdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392AbXKLWdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 17:33:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755600AbXKLWdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 17:33:44 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57589
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755507AbXKLWdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 17:33:43 -0500
Date: Mon, 12 Nov 2007 14:33:42 -0800 (PST)
Message-Id: <20071112.143342.10809862.davem@davemloft.net>
To: kaber@trash.net
Cc: auke-jan.h.kok@intel.com, joonwpark81@gmail.com, netdev@vger.kernel.org,
       djohnson+linux-kernel@sw.starentnetworks.com,
       linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/2] [e1000 VLAN] Disable vlan hw accel when
 promiscuous mode
From: David Miller <davem@davemloft.net>
In-Reply-To: <47388B9F.7050308@trash.net>
References: <47365200.0f10240a.0686.2173@mx.google.com>
	<47388988.1000506@intel.com>
	<47388B9F.7050308@trash.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 12 Nov 2007 18:21:35 +0100

> Do you really consider that a realistic choice? Who is going to
> remove interfaces that are in use just to see traffic for other
> VLANs? Sniffing specific VLANs can always be done on the VLAN
> device itself.

Change the example to wanting to see traffic on another
physical switch.

How is this any different?

> IMO its more a question of what we want promiscous mode to mean,
> and I tend to agree with Joonwoo that it should receive all packets.

On what LAN?

When you select VLAN, you by definition are asking for non-VLAN
traffic to be elided.  It is like plugging the ethernet cable
into one switch or another.
