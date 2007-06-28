Return-Path: <linux-kernel-owner+w=401wt.eu-S1763677AbXF1Lob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763677AbXF1Lob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 07:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758122AbXF1LoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 07:44:23 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55980 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757300AbXF1LoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 07:44:23 -0400
Subject: Re: [PATCH] LinuxPPS (with new syscalls API)
From: David Woodhouse <dwmw2@infradead.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070628084003.GQ13886@enneenne.com>
References: <20070627101449.GH13886@enneenne.com>
	 <1182939510.6409.17.camel@pmac.infradead.org>
	 <20070627125802.GI13886@enneenne.com>
	 <1182960660.1170.12.camel@pmac.infradead.org>
	 <20070627174537.GM13886@enneenne.com>
	 <1182966588.1170.28.camel@pmac.infradead.org>
	 <20070627224623.GO13886@enneenne.com>
	 <1183018133.1170.46.camel@pmac.infradead.org>
	 <20070628081538.GP13886@enneenne.com>
	 <1183019474.1170.66.camel@pmac.infradead.org>
	 <20070628084003.GQ13886@enneenne.com>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 28 Jun 2007 12:44:20 +0100
Message-Id: <1183031060.1170.145.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-28 at 10:40 +0200, Rodolfo Giometti wrote:
> On Thu, Jun 28, 2007 at 09:31:14AM +0100, David Woodhouse wrote:
> > On Thu, 2007-06-28 at 10:15 +0200, Rodolfo Giometti wrote:
> > > Do you think I should add these functions into my patch, even if I
> > > cannot test it, or it's enought providing just the
> > > compat_sys_time_pps_fetch() function? 
> > 
> > Probably best to put them in. That way, you make it easier for people to
> 
> Mmm... so I should provide new syscalls for _all_
> architectures... gulp! :)

It's nice if you can do so, but I wouldn't suggest that you _have_ to.
I have to admit that I rarely bother actually wiring new system calls up
on anything but PowerPC to start with.

The important thing is that you've _considered_ the other architectures,
and the 32/64 compatibility implications. As long as the API of your new
system call is sensible and takes that kind of thing into account, it
should be fine.

Had you considered changing the API so that you don't need the
compatibility wrapper at all? Could you take an integer number of µS or
ms instead of a struct timespec?

-- 
dwmw2

