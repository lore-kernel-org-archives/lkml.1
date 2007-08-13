Return-Path: <linux-kernel-owner+w=401wt.eu-S936431AbXHMXPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936431AbXHMXPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 19:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756784AbXHMXPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 19:15:06 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44791 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756407AbXHMXPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 19:15:03 -0400
Date: Tue, 14 Aug 2007 00:22:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>, Andi Kleen <ak@suse.de>,
       Mel Gorman <mel@skynet.ie>, Lee.Schermerhorn@hp.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] Embed zone_id information within the
 zonelist->zones pointer
Message-ID: <20070814002223.2d8d42c5@the-village.bc.nu>
In-Reply-To: <20070814000041.GL3406@bingen.suse.de>
References: <200708110304.55433.ak@suse.de>
	<Pine.LNX.4.64.0708131423050.28026@schroedinger.engr.sgi.com>
	<20070813225020.GE3406@bingen.suse.de>
	<Pine.LNX.4.64.0708131457190.28445@schroedinger.engr.sgi.com>
	<20070813225841.GG3406@bingen.suse.de>
	<Pine.LNX.4.64.0708131506030.28502@schroedinger.engr.sgi.com>
	<20070813230801.GH3406@bingen.suse.de>
	<Pine.LNX.4.64.0708131536340.29946@schroedinger.engr.sgi.com>
	<20070813234322.GJ3406@bingen.suse.de>
	<Pine.LNX.4.64.0708131553050.30626@schroedinger.engr.sgi.com>
	<20070814000041.GL3406@bingen.suse.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The only tricky part were skbs in a few drivers, but luckily they are only
> needed for bouncing which can be done without a skb too. For RX it adds
> one copy, but we can live with that because they're only slow devices.

Usually found on slow hardware that can't cope with extra copies very
well.

Alan
