Return-Path: <linux-kernel-owner+w=401wt.eu-S1760098AbYGRUMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760098AbYGRUMZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 16:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755551AbYGRUMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 16:12:17 -0400
Received: from waste.org ([66.93.16.53]:55001 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755275AbYGRUMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 16:12:16 -0400
Subject: Re: [RFC PATCH 1/4] kmemtrace: Core implementation.
From: Matt Mackall <mpm@selenic.com>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, cl@linux-foundation.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>
In-Reply-To: <20080718194059.GA5238@localhost>
References: <cover.1216255034.git.eduard.munteanu@linux360.ro>
	 <4472a3f883b0d9026bb2d8c490233b3eadf9b55e.1216255035.git.eduard.munteanu@linux360.ro>
	 <84144f020807170101x25c9be11qd6e1996460bb24fc@mail.gmail.com>
	 <20080717183206.GC5360@localhost>
	 <Pine.LNX.4.64.0807181140400.3739@sbz-30.cs.Helsinki.FI>
	 <20080718101326.GB5193@localhost>
	 <84144f020807180738m768a3ebana5ebc10999f22f50@mail.gmail.com>
	 <20080718194059.GA5238@localhost>
Content-Type: text/plain
Date: Fri, 18 Jul 2008 15:07:20 -0500
Message-Id: <1216411640.3712.16.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-07-18 at 22:40 +0300, Eduard - Gabriel Munteanu wrote:
> On Fri, Jul 18, 2008 at 05:38:04PM +0300, Pekka Enberg wrote:
> > Hi Eduard-Gabriel,
> > > I do expect to keep things source-compatible, but even
> > > binary-compatible? Developers debug and write patches on the latest kernel,
> > > not on a 6-month-old kernel. Isn't it reasonable that they would
> > > recompile kmemtrace along with the kernel?
> > 
> > Yes, I do think it's unreasonable. I, for one, am hoping distributions
> > will pick up the kmemtrace userspace at some point after which I don't
> > need to ever compile it myself.
> 
> Ok, I agree it's nice to have it in distros. I wasn't planning for this,
> but it's good to know others' expectations.

It's worth pointing out that this is one of the big downfalls of things
like systemtap. If a tool can't just work out of the box for a distro,
it's basically a non-starter for most users.

-- 
Mathematics is the supreme nostalgia of our time.

