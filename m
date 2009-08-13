Return-Path: <linux-kernel-owner+w=401wt.eu-S1756450AbZHMX1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450AbZHMX1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 19:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755919AbZHMX1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 19:27:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56547
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754403AbZHMX1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 19:27:05 -0400
Date: Thu, 13 Aug 2009 16:27:16 -0700 (PDT)
Message-Id: <20090813.162716.207478915.davem@davemloft.net>
To: anna.fischer@hp.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       shemminger@linux-foundation.org, ptcongdon@ucdavis.edu,
       evb@yahoogroups.com, bridge@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, kaber@trash.net,
       arnd@arndb.de, mike.dickson@hp.com, adobriyan@gmail.com,
       bridge@osdl.org
Subject: Re: [PATCH] net/bridge: Add 'hairpin' port forwarding mode
From: David Miller <davem@davemloft.net>
In-Reply-To: <0199E0D51A61344794750DC57738F58E6D6B0C70D9@GVW1118EXC.americas.hpqcorp.net>
References: <0199E0D51A61344794750DC57738F58E6D6B0C70D9@GVW1118EXC.americas.hpqcorp.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Fischer, Anna" <anna.fischer@hp.com>
Date: Thu, 13 Aug 2009 16:55:16 +0000

> This patch adds a 'hairpin' (also called 'reflective relay') mode
> port configuration to the Linux Ethernet bridge kernel module.
> A bridge supporting hairpin forwarding mode can send frames back
> out through the port the frame was received on.
> 
> Hairpin mode is required to support basic VEPA (Virtual
> Ethernet Port Aggregator) capabilities.
> 
> You can find additional information on VEPA here:
> http://tech.groups.yahoo.com/group/evb/
> http://www.ieee802.org/1/files/public/docs2009/new-hudson-vepa_seminar-20090514d.pdf
> http://www.internet2.edu/presentations/jt2009jul/20090719-congdon.pdf
> 
> An additional patch 'bridge-utils: Add 'hairpin' port forwarding mode'
> is provided to allow configuring hairpin mode from userspace tools.
> 
> Signed-off-by: Paul Congdon <paul.congdon@hp.com>
> Signed-off-by: Anna Fischer <anna.fischer@hp.com>

Applied to net-next-2.6
