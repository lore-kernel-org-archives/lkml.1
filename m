Return-Path: <linux-kernel-owner+w=401wt.eu-S1755306AbYFINXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbYFINXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 09:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750993AbYFINXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 09:23:00 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:50871 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbYFINXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 09:23:00 -0400
Date: Mon, 9 Jun 2008 15:22:53 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: benh@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/4] drivers/macintosh/smu.c: add missing of_node_put
In-Reply-To: <20080609230752.f3bba16d.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0806091521390.16009@ask.diku.dk>
References: <Pine.LNX.4.64.0806091420080.16009@ask.diku.dk>
 <20080609230752.f3bba16d.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> However, the error handling in that routine (smu_init) needs much more
> work.

Indeed, the smu = NULL at the end of the function seems a bit brutal - a 
lot of allocated data ends up not getting freed.  I can try to do 
something about it.  Did you see something else?

julia

