Return-Path: <linux-kernel-owner+w=401wt.eu-S933772AbZARQLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933772AbZARQLY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 11:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757237AbZARQLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 11:11:13 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:54676 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756080AbZARQLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 11:11:12 -0500
Date: Sun, 18 Jan 2009 17:11:10 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Hannes Eder <hannes@hanneseder.net>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       dri-devel@lists.sourceforge.net, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] drivers/gpu/drm: fix sparse warnings: unexport
 symbols
In-Reply-To: <154e089b0901180804k46e9411lcbc10f591871b14@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0901181710000.661@ask.diku.dk>
References: <20090118152725.4179.40835.stgit@vmbox.hanneseder.net> 
 <20090118152848.4179.85741.stgit@vmbox.hanneseder.net> 
 <1232294164.24415.3.camel@localhost.localdomain>
 <154e089b0901180804k46e9411lcbc10f591871b14@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> -EXPORT_SYMBOL(drm_mode_validate_clocks);
> >
> > ??
> 
> In both cases: a grep over the entire kernel tree shows that the
> function is only used within the compilation unit it is defined,
> therefore make it static and un-EXPORT it.

I don't know anything about this specific context, but aren't things in 
general exported so that external modules can use them?  If that is the 
case, grepping over the kernel sources is not sufficient.

julia
