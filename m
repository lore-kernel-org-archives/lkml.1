Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102AbZADCyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbZADCyT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 21:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751743AbZADCyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 21:54:06 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:46736
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbZADCyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 21:54:05 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "Leon Woestenberg" <leon.woestenberg@gmail.com>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Date: Sat, 3 Jan 2009 20:53:59 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Embedded Linux mailing list" <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Sam Ravnborg" <sam@ravnborg.org>
References: <200901020207.30359.rob@landley.net> <495FEEAF.5020005@zytor.com> <c384c5ea0901031637k3b571313m934c8881dce1c81@mail.gmail.com>
In-Reply-To: <c384c5ea0901031637k3b571313m934c8881dce1c81@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901032054.00018.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 January 2009 18:37:12 Leon Woestenberg wrote:
> Hello,
>
> On Sun, Jan 4, 2009 at 12:03 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> >> Dependencies very quickly become dependency hell. If A requires B,
> >> then A also inherits all (future) requirements of B, etc. etc.
> >>
> >> In my daily software development work with Linux and GNU software in
> >> general, 10% of it is spent fighting/removing these extremely "thin"
> >> or false depencies, so that it is usuable in embedded devices.
> >
> > First of all, I largely consider this a joke.  All real-life embedded
> > kernel builds take place on hosted platforms; anything else seems to be
> > done "just because it can be done", as a kind of show-off art project.
> > Cute, but hardly worth impeding the rest of the kernel community for.
>
> Let me explain why it is not a joke for me, although yes I agree it's
> a funny way of how software engineering works.
>
> My argument on thin dependencies indeed mostly holds for run-time
> dependencies (to reduce size) but also for build dependency (to reduce
> complexity)*.

I usually just point to the gnucash 1.6 release as where this sort of thing 
leads if you ignore it long enough:
http://lwn.net/2001/0614/

These days, a more modern example is the way that after even the gentoo folks 
gave up on trying to build openoffice (and shipped prebuilt binaries of it in 
their "build everything from source code" OS), Open Office's own developers 
described that project "profoundly sick" and "stagnating" ( 
http://developers.slashdot.org/article.pl?sid=08/12/28/0124230 ).

Neither project _started_ with an inbred development community that presented 
a brick wall to new developers.  Complexity grew because they didn't fight 
against it, and because they didn't have good rules by which they could say 
"no" to any.

Environmental dependencies in your build environment are a cost, and as with 
all costs it's ok if you get enough in return for it.  The Linux kernel has 
historically been extremely lean in this regard, and discarding that strength 
should at the very least come with commensurate concrete benefits.

Rob
