Return-Path: <linux-kernel-owner+w=401wt.eu-S935054AbXEIA2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935054AbXEIA2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 20:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbXEIA2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 20:28:31 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44579 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752064AbXEIA2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 20:28:31 -0400
Date: Wed, 9 May 2007 01:32:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matt Mackall <mpm@selenic.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, clameter@sgi.com
Subject: Re: + fix-spellings-of-slab-allocator-section-in-init-kconfig.patch
 added to -mm tree
Message-ID: <20070509013220.02093f2e@the-village.bc.nu>
In-Reply-To: <20070509002307.GV11115@waste.org>
References: <200705082302.l48N2KrZ004229@shell0.pdx.osdl.net>
	<20070509002307.GV11115@waste.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> (without SLAB emulation) and fragmentation was not the driving force
> for replacement. Small Linux 1.x machines frequently had uptimes of 1+
> years without fragmenting to death. Instead, it was performance with

8MB for a bit over 3 years.... (1.2.13lmp)

The fragmentation issue I think is overbaked. A lot of the academic work
argues that there is pretty much no long term difference between first
fit, best fit, and most of the clever algorithms (obviously stupid ones
like "take the middle out of the biggest space allocator" do perform
worse). For MMUless boxes fragmentation is a big issue but not for normal
systems.

Alan
