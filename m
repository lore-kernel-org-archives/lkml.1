Return-Path: <linux-kernel-owner+w=401wt.eu-S965673AbXDMXLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965673AbXDMXLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 19:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965687AbXDMXLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 19:11:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53879
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965673AbXDMXLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 19:11:46 -0400
Date: Fri, 13 Apr 2007 16:11:48 -0700 (PDT)
Message-Id: <20070413.161148.01040565.davem@davemloft.net>
To: j.borsboom@erasmusmc.nl
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] allow VLAN interface on top of bridge interface
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0704122136330.3170@knorkaan.xs4all.nl>
References: <Pine.LNX.4.64.0704122136330.3170@knorkaan.xs4all.nl>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jerome Borsboom <j.borsboom@erasmusmc.nl>
Date: Thu, 12 Apr 2007 21:50:00 +0200 (CEST)

> When a VLAN interface is created on top of a bridge interface and 
> netfilter is enabled to see the bridged packets, the packets can be 
> corrupted when passing through the netfilter code. This is caused by the 
> VLAN driver not setting the 'protocol' and 'nh' members of the sk_buff 
> structure. In general, this is no problem as the VLAN interface is mostly 
> connected to a physical ethernet interface which does not use the 
> 'protocol' and 'nh' members. For a bridge interface, however, these 
> members do matter.
> 
> Signed-off-by: Jerome Borsboom <j.borsboom@erasmusmc.nl>

I'll apply this, thanks a lot Jerome.
