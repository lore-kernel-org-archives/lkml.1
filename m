Return-Path: <linux-kernel-owner+w=401wt.eu-S965571AbXCBU0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965571AbXCBU0D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 15:26:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965572AbXCBU0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 15:26:03 -0500
Received: from hera.kernel.org ([140.211.167.34]:48271 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965571AbXCBU0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 15:26:01 -0500
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH] mv643xx ethernet driver
Date: Fri, 2 Mar 2007 12:24:43 -0800
Organization: OSDL
Message-ID: <20070302122443.48e8c2d1@freekitty>
References: <es8ahm$64p$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Trace: build.pdx.osdl.net 1172867083 15810 10.8.0.54 (2 Mar 2007 20:24:43 GMT)
X-Complaints-To: abuse@osdl.org
NNTP-Posting-Date: Fri, 2 Mar 2007 20:24:43 +0000 (UTC)
X-Newsreader: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Mar 2007 23:52:06 -0500
Giridhar Pemmasani <giri@lmc.cs.sunysb.edu> wrote:

> During initialization, mv643xx driver registers IRQ before setting up tx/rx
> rings. This causes kernel oops because mv643xx_poll, which gets called
> right after registering IRQ, calls netif_rx_complete, which accesses the rx
> ring (I don't have the oops message anymore; I just remember this sequence
> of calls). Attached (tested) patch first initializes the rx/tx rings and
> then registers the IRQ.
> 
> Giri

Wrong mailing list network device patches should be sent to:

NETWORK DEVICE DRIVERS
P:	Andrew Morton
M:	akpm@linux-foundation.org
P:	Jeff Garzik
M:	jgarzik@pobox.com
L:	netdev@vger.kernel.org
T:	git kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git
S:	Maintained

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
