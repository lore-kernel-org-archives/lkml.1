Return-Path: <linux-kernel-owner+w=401wt.eu-S1758793AbYHHSLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793AbYHHSLs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 14:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559AbYHHSL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 14:11:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38019 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754136AbYHHSL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 14:11:28 -0400
Date: Fri, 8 Aug 2008 18:54:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: linux-ide <linux-ide@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: issues with sata hotplug?
Message-ID: <20080808185419.69d762bc@lxorguk.ukuu.org.uk>
In-Reply-To: <5D4D272F-5546-4C02-852A-80849A42EC1F@kernel.crashing.org>
References: <5D4D272F-5546-4C02-852A-80849A42EC1F@kernel.crashing.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When I "eject" the drive I see no dmesg output related to hotplug.  I  
> also don't see anything when I plug a drive in.

sata_nv does support hot plug and hot plug events.

> Is there something I'm doing wrong w/regards to SATA hotplug support?

Not that I can see - you can warm plug drives by telling the kernel
yourself about plug/unplug events.

