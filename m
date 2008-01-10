Return-Path: <linux-kernel-owner+w=401wt.eu-S1757642AbYAJCaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642AbYAJCaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 21:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbYAJCao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 21:30:44 -0500
Received: from waste.org ([66.93.16.53]:46033 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037AbYAJCan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 21:30:43 -0500
Subject: Re: Replacement for page fault notifiers?
From: Matt Mackall <mpm@selenic.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Dave Airlie <airlied@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       linux-kernel@vger.kernel.org, jbeulich@novell.com
In-Reply-To: <1199931693.21499.11.camel@dv>
References: <20080108210638.5c9e093a@daedalus.pq.iki.fi>
	 <20080108203235.GA772@infradead.org>
	 <21d7e9970801081413n307ab07aq462a9fff014143ae@mail.gmail.com>
	 <1199838407.6734.83.camel@pasglop> <1199902724.8050.11.camel@dv>
	 <20080109182157.GA32754@infradead.org> <1199908703.6734.133.camel@pasglop>
	 <20080109202254.GA5279@infradead.org>
	 <20080109164241.7daa5770@laptopd505.fenrus.org>
	 <1199930590.6245.104.camel@cinder.waste.org> <1199931693.21499.11.camel@dv>
Content-Type: text/plain
Date: Wed, 09 Jan 2008 20:30:04 -0600
Message-Id: <1199932204.6245.110.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-09 at 21:21 -0500, Pavel Roskin wrote:
> On Wed, 2008-01-09 at 20:03 -0600, Matt Mackall wrote:
> 
> > That makes it way too easy for drivers of questionable legality to just
> > clear that bit. Also, we've got a shortage of page bits, etc.
> 
> If we ever have this problem, the bit can be changed in the kernel to
> fool those drivers (I hope the shortage is not so dire that there will
> be no more bits left).

That's what we call an arms race. And yes, page bits are close to
running out on 32-bit.

> I don't think evil drivers should be a problem per se.  There are
> existing non-free drivers that still need to be traced over and over
> again.  I guess ndiswrapper could use tracing for Windows drivers that
> don't know anything about Linux page flags.
> 
> Last but not least, mmiotrace should be useful for free drivers in the
> first place to have a legitimate reason to be in the kernel.

I definitely agree that tracing MMIO is an extremely useful feature.
I've implemented it myself once already for 2.4.

-- 
Mathematics is the supreme nostalgia of our time.

