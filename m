Return-Path: <linux-kernel-owner+w=401wt.eu-S1759977AbXKLW25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759977AbXKLW25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 17:28:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756633AbXKLW2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 17:28:47 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49057
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755763AbXKLW2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 17:28:46 -0500
Date: Mon, 12 Nov 2007 14:28:45 -0800 (PST)
Message-Id: <20071112.142845.154035709.davem@davemloft.net>
To: auke-jan.h.kok@intel.com
Cc: joonwpark81@gmail.com, netdev@vger.kernel.org,
       djohnson+linux-kernel@sw.starentnetworks.com,
       linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/2] [e1000 VLAN] Disable vlan hw accel when
 promiscuous mode
From: David Miller <davem@davemloft.net>
In-Reply-To: <47388988.1000506@intel.com>
References: <47365200.0f10240a.0686.2173@mx.google.com>
	<47388988.1000506@intel.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kok, Auke" <auke-jan.h.kok@intel.com>
Date: Mon, 12 Nov 2007 09:12:40 -0800

> Actually I think this patch removes a choice from the user.
> 
> Before this patch, the user can sniff all traffic by disabling vlans, or a
> specific vlan only by leaving vlans on when going into promisc mode.
> 
> After this patch, the user has no choice but to sniff all vlans at all times.
> 
> I don't think that that is such a good improvement.

I agree.

Look at the VLAN setting as being just like moving the
ethernet cable from one switch to another.

There is no logical difference.
