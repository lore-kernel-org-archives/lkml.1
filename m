Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbYBORDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbYBORDX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 12:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbYBORDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 12:03:15 -0500
Received: from waste.org ([66.93.16.53]:34732 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbYBORDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 12:03:14 -0500
Subject: Re: [PATCH] Configure out doublefault exception handler (Linux
	Tiny)
From: Matt Mackall <mpm@selenic.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
       Sam Ravnborg <sam@ravnborg.org>, Linux-tiny@selenic.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "H. Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <p73tzkazaxh.fsf@bingen.suse.de>
References: <20080212110825.35db27cb@crazy>
	 <20080212130428.GA32757@uranus.ravnborg.org>
	 <20080212150013.57cb954e@crazy>
	 <1202832132.12383.93.camel@cinder.waste.org>
	 <p73tzkazaxh.fsf@bingen.suse.de>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 11:02:16 -0600
Message-Id: <1203094937.12383.212.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-15 at 13:00 +0100, Andi Kleen wrote:
> Matt Mackall <mpm@selenic.com> writes:
> >
> > I bet there's some doublefault-handling code hiding somewhere. It's not
> > the sort of thing it'd make sense to take out of the architecture.
> 
> The big question is if it makes sense taking out of a kernel at all.
> I still think the answer is no.
> 
> Or have you considered replacing die() and show_trace() etc. with a single
> panic("the tiny gods say this won't happen") yet? That would be roughly 
> equivalent.

It's not a matter of "won't happen" so much as "not a damn thing we can
do when it does". There's very little point in having this sort of code
in a mass-market camera, phone, DVR, TV, etc. (of which there are
already millions running Linux). These devices have no console and
basically zero serviceability beyond firmware upgrades. If taking these
vestigial debugging features out means we can cram in more features that
consumers can actually see and will pay for, that's precisely what's
going to happen.

-- 
Mathematics is the supreme nostalgia of our time.

