Return-Path: <linux-kernel-owner+w=401wt.eu-S1756161AbZKUP4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbZKUP4t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 10:56:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032AbZKUP4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 10:56:48 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:41689 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754922AbZKUP4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 10:56:48 -0500
Date: Sat, 21 Nov 2009 16:56:52 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: walter harms <wharms@bfs.de>, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/8] drivers/pcmcia: remove unnecessary kzalloc
In-Reply-To: <20091121155135.GB13956@n2100.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0911211656170.26930@ask.diku.dk>
References: <Pine.LNX.4.64.0911211250090.23681@ask.diku.dk> <4B07E0CB.6000508@bfs.de>
 <Pine.LNX.4.64.0911211611510.26930@ask.diku.dk> <20091121155135.GB13956@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Just remove the first kzalloc and don't convert it to an array; that's the
> safest option.  I don't remember if there's a reason why I switched to a
> linked list - however, what I will say is that the way all the sa11xx
> and pxa stuff interact is not plainly obvious.

OK, that is what my patch does.  Thanks for looking into it.

julia
