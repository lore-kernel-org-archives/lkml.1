Return-Path: <linux-kernel-owner+w=401wt.eu-S1757073AbYHATrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073AbYHATrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 15:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYHATrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 15:47:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48002 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbYHATrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 15:47:35 -0400
Subject: Re: [patch 0/4] [resend] Add configuration options to disable
	features
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Josh Boyer <jwboyer@gmail.com>,
       Ulrich Teichert <krypton@ulrich-teichert.org>,
       Tim Bird <tim.bird@am.sony.com>, David Miller <davem@davemloft.net>,
       thomas.petazzoni@free-electrons.com, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, michael@free-electrons.com
In-Reply-To: <alpine.LFD.1.10.0808011212430.3277@nehalem.linux-foundation.org>
References: <200807311850.m6VIoqCE015883@arbas.nms.ulrich-teichert.org>
	 <1217533588.2328.1.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0808011212430.3277@nehalem.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 01 Aug 2008 20:47:23 +0100
Message-Id: <1217620043.3454.492.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-01 at 12:15 -0700, Linus Torvalds wrote:
> 
> On Thu, 31 Jul 2008, Josh Boyer wrote:
> > On Thu, 2008-07-31 at 20:50 +0200, Ulrich Teichert wrote:
> > > 
> > > I do not think of NTP as desktop or server application, but that's
> > > probably just me,
> > 
> > No, it's not just you.  NTP is useful in cases where things do care
> > about time but hardware designers were too cheap to put an RTC on the
> > board.
> 
> In fact, didn't one of the netgear firewall/switch/routers end up being 
> famous for overloading some NTP service exactly because all the _millions_ 
> of routers ended up using the same (incorrect) NTP host?
> 
> So NTP is very definitely an embedded thing too.

And it's _still_ a red herring.

I just booted a !CONFIG_IGMP kernel on my workstation and NTP is running
just fine (as is IPv6).

Even though ntpd has a configure test for multicast and can be built
without multicast support at all, it isn't even necessary to build it
that way -- the stock Fedora build of it works just fine.

(Actually, I never managed to get ntpd to work _with_ multicast, but
that's a different issue... :)

-- 
dwmw2

