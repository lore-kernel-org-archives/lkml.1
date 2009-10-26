Return-Path: <linux-kernel-owner+w=401wt.eu-S1754772AbZJZF5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbZJZF5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 01:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754739AbZJZF5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 01:57:38 -0400
Received: from mail.gmx.net ([213.165.64.20]:57126 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754738AbZJZF5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 01:57:38 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19tCdNh+NFt7aVRWiuvCCpdi19FXeKuw7Fl4Drn0r
	J6QFsz8cZf6ZMN
Subject: Re: [PATCH 3/3] sched: Disable affine wakeups by default
From: Mike Galbraith <efault@gmx.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <1256536078.7117.67.camel@marge.simson.net>
References: <20091024125853.35143117@infradead.org>
	 <20091024130432.0c46ef27@infradead.org>
	 <20091024130728.051c4d7c@infradead.org>
	 <1256453725.12138.40.camel@marge.simson.net>
	 <20091025095109.449bac9e@infradead.org>
	 <1256492289.14241.40.camel@marge.simson.net>
	 <20091025123319.2b76bf69@infradead.org>
	 <1256508287.17306.14.camel@marge.simson.net>
	 <1256522035.7356.19.camel@laptop>
	 <1256531907.7117.31.camel@marge.simson.net>
	 <20091025215225.05ac9ac9@infradead.org>
	 <1256533734.7117.45.camel@marge.simson.net>
	 <20091025223657.5ebc2857@infradead.org>
	 <1256536078.7117.67.camel@marge.simson.net>
Content-Type: text/plain
Date: Mon, 26 Oct 2009 06:57:40 +0100
Message-Id: <1256536660.8150.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-26 at 06:47 +0100, Mike Galbraith wrote:
> On Sun, 2009-10-25 at 22:36 -0700, Arjan van de Ven wrote:

> > if you're a multicore domain you better have a shared cache.. that's
> > what it should mean. If it does not we should fix that.
> 
> Sounds reasonable to me.  I'll go make explosions.

(Actually, if multicode and sibling does indeed mean shared cache, no
arch tinkering should be necessary, just reset SD_WAKE_AFFINE when
degenerating should work fine.  Only thing is multicore with siblings..
and test test test)

	-Mike

