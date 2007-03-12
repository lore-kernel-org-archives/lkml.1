Return-Path: <linux-kernel-owner+w=401wt.eu-S965886AbXCLOWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965886AbXCLOWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 10:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965887AbXCLOWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 10:22:00 -0400
Received: from [212.12.190.20] ([212.12.190.20]:32981 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S965886AbXCLOV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 10:21:59 -0400
From: Al Boldi <a1426z@gawab.com>
To: Con Kolivas <kernel@kolivas.org>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler
Date: Mon, 12 Mar 2007 17:14:24 +0300
User-Agent: KMail/1.5
Cc: ck list <ck@vds.kolivas.org>, linux-kernel@vger.kernel.org
References: <200703042335.26785.a1426z@gawab.com> <200703121426.00854.a1426z@gawab.com> <200703122352.51257.kernel@kolivas.org>
In-Reply-To: <200703122352.51257.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703121714.25034.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> > > The higher priority one always get 6-7ms whereas the lower priority
> > > one runs 6-7ms and then one larger perfectly bound expiration amount.
> > > Basically exactly as I'd expect. The higher priority task gets
> > > precisely RR_INTERVAL maximum latency whereas the lower priority task
> > > gets RR_INTERVAL min and full expiration (according to the virtual
> > > deadline) as a maximum. That's exactly how I intend it to work. Yes I
> > > realise that the max latency ends up being longer intermittently on
> > > the niced task but that's -in my opinion- perfectly fine as a
> > > compromise to ensure the nice 0 one always gets low latency.
> >
> > I think, it should be possible to spread this max expiration latency
> > across the rotation, should it not?
>
> There is a way that I toyed with of creating maps of slots to use for each
> different priority, but it broke the O(1) nature of the virtual deadline
> management. Minimising algorithmic complexity seemed more important to
> maintain than getting slightly better latency spreads for niced tasks. It
> also appeared to be less cache friendly in design. I could certainly try
> and implement it but how much importance are we to place on latency of
> niced tasks? Are you aware of any usage scenario where latency sensitive
> tasks are ever significantly niced in the real world?

It only takes one negatively nice'd proc to affect X adversely.


Thanks!

--
Al

