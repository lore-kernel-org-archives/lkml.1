Return-Path: <linux-kernel-owner+w=401wt.eu-S1767941AbXEEBwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767941AbXEEBwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 21:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767942AbXEEBwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 21:52:51 -0400
Received: from bee.hiwaay.net ([216.180.54.11]:59084 "EHLO bee.hiwaay.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767941AbXEEBwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 21:52:50 -0400
Date: Fri, 4 May 2007 20:52:47 -0500
From: Chris Adams <cmadams@hiwaay.net>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ExpressCard hotswap support?
Message-ID: <20070505015246.GD1004160@hiwaay.net>
References: <6278d2220705040304n6bfe14e8h7d3a1302315f36a5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6278d2220705040304n6bfe14e8h7d3a1302315f36a5@mail.gmail.com>
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Once upon a time, Daniel J Blueman <daniel.blueman@gmail.com> said:
> On 4 May, 01:20, Chris Adams <cmadams@hiwaay.net> wrote:
> >I've got a Thinkpad Z60m with an ExpressCard slot, and I got a Belkin
> >F5U250 GigE ExpressCard (Marvell 88E8053 chip using sky2 driver).  It
> >appears that Linux only recognizes it if I insert the card with the
> >system powered off.  If I hot-insert the card, nothing happens (no
> >messages logged, no PCI device shows up, nothing).
> 
> The BIOS initialises and powers up the downstream PCI express port
> when it detects a card is present.
> 
> When Linux boots, it enumerates the bus and sees it, but does not do
> prior configuration to enable, configure and cause link negotiation on
> all PCI express ports I believe; this requires chipset and (sometimes
> revision-) specific code, which wouldn't be so robust as the BIOS
> doing the footwork.

Actually, for me, loading pciehp with pciehp_force=1 set works.
-- 
Chris Adams <cmadams@hiwaay.net>
Systems and Network Administrator - HiWAAY Internet Services
I don't speak for anybody but myself - that's enough trouble.
