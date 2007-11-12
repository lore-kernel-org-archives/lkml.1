Return-Path: <linux-kernel-owner+w=401wt.eu-S1760219AbXKLW53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760219AbXKLW53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 17:57:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755600AbXKLW5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 17:57:18 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45545
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755325AbXKLW5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 17:57:18 -0500
Date: Mon, 12 Nov 2007 14:57:16 -0800 (PST)
Message-Id: <20071112.145716.06352378.davem@davemloft.net>
To: cfriesen@nortel.com
Cc: kaber@trash.net, auke-jan.h.kok@intel.com, joonwpark81@gmail.com,
       netdev@vger.kernel.org, djohnson+linux-kernel@sw.starentnetworks.com,
       linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/2] [e1000 VLAN] Disable vlan hw accel when
 promiscuous mode
From: David Miller <davem@davemloft.net>
In-Reply-To: <4738D70C.4060404@nortel.com>
References: <47388B9F.7050308@trash.net>
	<20071112.143342.10809862.davem@davemloft.net>
	<4738D70C.4060404@nortel.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Chris Friesen" <cfriesen@nortel.com>
Date: Mon, 12 Nov 2007 16:43:24 -0600

> David Miller wrote:
> 
> > When you select VLAN, you by definition are asking for non-VLAN
> > traffic to be elided.  It is like plugging the ethernet cable
> > into one switch or another.
> 
> For max functionality it seems like the raw eth device should show 
> everything on the wire in promiscuous mode.
> 
> If we want to sniff only the traffic for a specific vlan, we can sniff 
> the vlan device.

VLAN settings are a filter of sorts, much like plugging into
one switch or another filters traffic physically.

If you don't want that filter, turn the VLAN settings off.
