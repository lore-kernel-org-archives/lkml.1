Return-Path: <linux-kernel-owner+w=401wt.eu-S1754845AbXJ2WKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbXJ2WKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 18:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbXJ2WKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 18:10:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49940
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753146AbXJ2WKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 18:10:23 -0400
Date: Mon, 29 Oct 2007 15:10:25 -0700 (PDT)
Message-Id: <20071029.151025.87460351.davem@davemloft.net>
To: jengelh@computergmbh.de
Cc: toms@wonderland.us.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: drivers/net/sunhme.c patch
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0710291606260.26070@fbirervta.pbzchgretzou.qr>
References: <4725F416.2030100@wonderland.us.com>
	<Pine.LNX.4.64.0710291606260.26070@fbirervta.pbzchgretzou.qr>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Engelhardt <jengelh@computergmbh.de>
Date: Mon, 29 Oct 2007 16:11:18 +0100 (CET)

> 
> On Oct 29 2007 08:54, Tom Southerland wrote:
> >
> > This patch provides a unique mac address for all interfaces
> > for the Sun QFE card (non-sparc).  It takes the base mac from
> > the first interface and increments the mac address for the
> > other interfaces.
> 
> Where is the difference to a SPARC QFE? PCI is PCI after all, is not it?

This is exactly why I wish this patch had been posted to
netdev@vger.kernel.org, now we have a dialogue going and even if I add
netdev to the CC: now, you can't follow it completely as a netdev
subscriber without going to the lkml archives.

To answer the question, yes it is just a normal PCI device, they put 4
HME chips behind a PCI bridge.  However, the OpenFirmware on the cards
usually creates device node properties for these PCI devices for the
local ethernet addresses.  That's what he's trying to duplicate here.
