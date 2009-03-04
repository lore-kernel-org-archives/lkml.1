Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbZCDK7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbZCDK7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 05:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbZCDK7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 05:59:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52132
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752624AbZCDK73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 05:59:29 -0500
Date: Wed, 04 Mar 2009 02:59:14 -0800 (PST)
Message-Id: <20090304.025914.149394356.davem@davemloft.net>
To: kaber@trash.net
Cc: bart@jukie.net, greearb@candelatech.com, shemminger@vyatta.com,
       dada1@cosmosbay.com, frank.blaschka@de.ibm.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.29-rc* QinQ vlan trunking regression
From: David Miller <davem@davemloft.net>
In-Reply-To: <49AE509B.3000305@trash.net>
References: <20090228180541.GA729@jukie.net>
	<20090303.234327.81716668.davem@davemloft.net>
	<49AE509B.3000305@trash.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Wed, 04 Mar 2009 10:57:47 +0100

> David Miller wrote:
> > From: Bart Trojanowski <bart@jukie.net>
> > Date: Sat, 28 Feb 2009 13:05:41 -0500
> > 
> >> 2.6.29-rc* introduces a bug that causes a crash when a vlan is put into
> >> another vlan, so called vlan trunking or QinQ.
> >>
> >> I can reproduce it reliably with:
> >>
> >>   $ modprobe 8021q
> >>   $ vconfig add eth1 5
> >>   $ ifconfig eth1.5 up
> >>   $ vconfig add eth1.5 4
> > Stephen please fix this.
> 
> I'm maintaining vlan :) I haven't been able to look into this yet,
> but I should be later today.

Ok, I don't actually care who fixes it :-)

I asked Stephen because this appears like it might be netdev_ops
fallout.
