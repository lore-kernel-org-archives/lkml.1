Return-Path: <linux-kernel-owner+w=401wt.eu-S1752217AbXFYVGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbXFYVGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 17:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbXFYVGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 17:06:00 -0400
Received: from mail.gmx.net ([213.165.64.20]:35805 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751739AbXFYVF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 17:05:59 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1/yncFmDXzyMWqKgRQPehMKLGLsdrCbKunUtghshN
	mplS3qPVhjWzqh
Date: Mon, 25 Jun 2007 23:06:47 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, eranian@hpl.hp.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org, levon@movementarian.org,
       perfmon@napali.hpl.hp.com, oprofile-list@lists.sourceforge.net,
       wcohen@redhat.com
Subject: Re: [PATCH 1/2] Always probe the NMI watchdog
Message-ID: <20070625210647.GB15258@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
	eranian@hpl.hp.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
	levon@movementarian.org, perfmon@napali.hpl.hp.com,
	oprofile-list@lists.sourceforge.net, wcohen@redhat.com
References: <20070618103214.GA12045@atjola.homenet> <20070620183448.GB3251@atjola.homenet> <20070625120926.0a86373c.akpm@linux-foundation.org> <200706252136.18366.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200706252136.18366.ak@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.06.25 21:36:17 +0200, Andi Kleen wrote:
> On Monday 25 June 2007 21:09, Andrew Morton wrote:
> > On Wed, 20 Jun 2007 20:34:48 +0200
> >
> > Bj__rn Steinbrink <B.Steinbrink@gmx.de> wrote:
> > > The performance counter allocator relies on the nmi watchdog being
> > > probed, so we have to do that even if the watchdog is not enabled.
> >
> > So...  what's the status of this lot?
> >
> > I've just merged this patch and the second one:
> >
> > Subject: [PATCH 2/2] Reserve the right performance counter for the Intel
> > PerfMon NMI watchdog Message-ID: <20070620183551.GC3251@atjola.homenet>
> >
> > but there was no followup discussion afaict.
> >
> > Andi, Stephane: acks?
> 
> Yes, although I'm still a little uneasy about the always probe one.
> 
> > If acked, do we agree that this is 2.6.22 material?
> 
> The first (always probe) is probably .22 material, but needs more testing 
> first.

Hm, without the second, I expect OProfile to break when the watchdog is
enabled. Alternatively to the patch I sent, we could revert the change
that makes it use perfctr1 instead of perfctr0. Would you prefer that?

Björn
