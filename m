Return-Path: <linux-kernel-owner+w=401wt.eu-S1758121AbYGaT4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121AbYGaT4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 15:56:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754374AbYGaTzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 15:55:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54633 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbYGaTzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 15:55:51 -0400
Subject: Re: [patch 0/4] [resend] Add configuration options to disable
	features
From: David Woodhouse <dwmw2@infradead.org>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Ulrich Teichert <krypton@ulrich-teichert.org>,
       Tim Bird <tim.bird@am.sony.com>, David Miller <davem@davemloft.net>,
       torvalds@linux-foundation.org, thomas.petazzoni@free-electrons.com,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       michael@free-electrons.com
In-Reply-To: <1217533588.2328.1.camel@localhost.localdomain>
References: <200807311850.m6VIoqCE015883@arbas.nms.ulrich-teichert.org>
	 <1217533588.2328.1.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 31 Jul 2008 20:55:34 +0100
Message-Id: <1217534134.3454.300.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-31 at 15:46 -0400, Josh Boyer wrote:
> On Thu, 2008-07-31 at 20:50 +0200, Ulrich Teichert wrote:
> > Hi,
> > 
> > >I don't know of any embedded products that ship with NTP turned
> > >on.
> > 
> > Well, I do. To be exact, I've developed parts of it. But it's numbers
> > are only into the thousands, so that makes it insignificant ;-)
> > 
> > >It's best to assume, with embedded, that we're not shipping
> > >ANY of the desktop or server applications you are familiar with.
> > >Absent those, does something break in the kernel with multicast
> > >support when IGMP is turned off?
> > 
> > I do not think of NTP as desktop or server application, but that's
> > probably just me,
> 
> No, it's not just you.  NTP is useful in cases where things do care
> about time but hardware designers were too cheap to put an RTC on the
> board.
> 
> I will admit that it's use in embedded products is probably very limited
> though.

NTP is a red herring. It has a check for multicast support in its
configure script and wraps it all in #ifdef MCAST anyway.

So even if it _does_ crap out when I build my standard distro kernel
with !CONFIG_IGMP and use the standard distro build of ntpd, that still
isn't particularly relevant to the kind of application where someone
would built a kernel without IGMP support and build their own ntpd to
match.

-- 
dwmw2

