Return-Path: <linux-kernel-owner+w=401wt.eu-S1755635AbZLTUQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbZLTUQd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 15:16:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754526AbZLTUQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 15:16:32 -0500
Received: from mail1.radix.net ([207.192.128.31]:49237 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516AbZLTUQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 15:16:31 -0500
Subject: Re: [PATCH 2/3] g_NCR5380: fix broken MMIO compilation
From: Andy Walls <awalls@radix.net>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200912202041.29363.linux@rainbow-software.org>
References: <200912202041.29363.linux@rainbow-software.org>
Content-Type: text/plain
Date: Sun, 20 Dec 2009 15:15:44 -0500
Message-Id: <1261340144.3057.21.camel@palomino.walls.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-20 at 20:41 +0100, Ondrej Zary wrote:
> The ifdefs are broken so the MMIO code is never compiled and so it's broken
> too. Fix them all.
> Untested as I don't have the hardware.

I still have a DTC-xxxx card in use (under Windows95) and a SUMO SCSI AT
(usable with g_NCR5380 with a minor hack to toggle a flip flop that
gates interrupts to the ISA bus).  :)

I think both cards are wired to use I/O space and not memory space, so
they are of no help for testing MMIO. :(  

But, ah memories....

Regards,
Andy

