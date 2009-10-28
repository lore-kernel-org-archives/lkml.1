Return-Path: <linux-kernel-owner+w=401wt.eu-S932584AbZJ1DUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584AbZJ1DUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 23:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932572AbZJ1DUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 23:20:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44889 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932532AbZJ1DUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 23:20:45 -0400
Date: Wed, 28 Oct 2009 04:20:49 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andy Walls <awalls@radix.net>
Cc: Stefani Seibold <stefani@seibold.net>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Amerigo Wang <xiyou.wangcong@gmail.com>,
       Joe Perches <joe@perches.com>, linux-media@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 0/7] kfifo: new API v0.6
Message-ID: <20091028032049.GB7744@basil.fritz.box>
References: <1256694571.3131.26.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256694571.3131.26.camel@palomino.walls.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Here's a V4L-DVB cx23885 module change, that is on its way upstream,
> that uses kfifo as is:
> 
> http://linuxtv.org/hg/v4l-dvb/rev/a2d8d3d88c6d
> 
> Do you really have to break the old API?

That was extensively discussed in the original patch kit submission,
and yes there are good reasons. You will just have to adapt
the driver if it gets in after the new kfifo patches; if kfifo
gets in later it'll have to adapt it.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
