Return-Path: <linux-kernel-owner+w=401wt.eu-S1752259AbZL1R0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbZL1R0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 12:26:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbZL1R0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 12:26:53 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42745 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbZL1R0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 12:26:53 -0500
Date: Mon, 28 Dec 2009 18:26:51 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       akpm@osdl.org
Subject: Re: [PATCH] [0/6] kfifo fixes/improvements
Message-ID: <20091228172651.GE4994@basil.fritz.box>
References: <200912271003.631128760@firstfloor.org> <1261949800.25298.18.camel@wall-e> <20091227233816.GC2399@basil.fritz.box> <1261986136.808.2.camel@wall-e> <20091228145749.GD4994@basil.fritz.box> <1262016510.12656.25.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262016510.12656.25.camel@wall-e>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


First having to rely on another large patchkit makes 
it annoying to develop for this (it's the linux kernel
equivalent of DLL hell), but ok. I hope the interface
doesn't change again at least.

> So please draw back this patch, you will get exactly what you want and
> need in the next release. I have now a clean, slim and fast
> implementation. All what i need is a review and some ack's

How about the current users for 2.6.33?  Unless they are not 
record oriented or always put in power-of-two records they will
need this patch, otherwise they risk desynchronization on fifo
full.

I think the patch is needed.

Also should drop the unused interfaces for 2.6.33 before anyone
else tries to use them and gets the same nasty surprise as me.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
