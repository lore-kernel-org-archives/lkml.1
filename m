Return-Path: <linux-kernel-owner+w=401wt.eu-S1752295AbZAEFIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295AbZAEFIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 00:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbZAEFIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 00:08:40 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:49982
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbZAEFIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 00:08:39 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: [PATCH 1/3]: Replace kernel/timeconst.pl with kernel/timeconst.sh
Date: Sun, 4 Jan 2009 23:08:26 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: "Embedded Linux mailing list" <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, "Sam Ravnborg" <sam@ravnborg.org>
References: <200901020207.30359.rob@landley.net> <200901020213.30658.rob@landley.net> <2c0942db0901041641v5546a1e2med4ca18fe8d2510f@mail.gmail.com>
In-Reply-To: <2c0942db0901041641v5546a1e2med4ca18fe8d2510f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901042308.27275.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 January 2009 18:41:15 Ray Lee wrote:
> On Fri, Jan 2, 2009 at 12:13 AM, Rob Landley <rob@landley.net> wrote:
> > Replace kernel/timeconst.pl with kernel/timeconst.sh.  The new shell
> > script is much simpler, about 1/4 the size, and runs on Red Hat 9 from
> > 2003.
> >
> > Peter Anvin added this perl to 2.6.25.  Before that, the kernel had never
> > required perl to build.
>
> Nice work.

Thanks.  You'll definitely want to look at the _second_ version of that patch 
rather than the first, though. :)

> As the computations can all be done in 64-bit precision
> now, and there have been concerns expressed about some shells not
> supporting 64 bit integers, is there any reason this can't be done
> using long longs in C?

Nope.  Any of this could be done in C.  (And that's the approach Sam Ravnborg 
prefers to take for the second patch in the series, upgrading unifdef.c to do 
everything itself.)

I tend to lean towards scripts that create header files rather than programs 
that create header files, but as long as you remember to use HOSTCC it's 
fairly straightforward. :)

> Other than ruining a good bike shed argument, anyway.

Oh pile on.  It beats being dismissed as the only one on the planet who cares 
about the issue (again). :)

Rob
