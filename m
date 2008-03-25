Return-Path: <linux-kernel-owner+w=401wt.eu-S1759647AbYCYXFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759647AbYCYXFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 19:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754860AbYCYXFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 19:05:30 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:1165 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370AbYCYXF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 19:05:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KGP7Z8Ya0P3S2W+lA5oBL0AOYitZLS4F1xl56WSfIuz8Oe3LYdgx0DhRo5yxnUt1XVd7hOrQNM+fWF7aQ9p3vZ08Dx4vFjbko076mOur5qwWlG+OE1/LdNkMFA3GDuALcEMotA94HP2suDH2TvqfPlM8JzUXjnvyFx8NotoJRfs=
Message-ID: <86802c440803251605w7021b60cmbc312eb9ca87d277@mail.gmail.com>
Date: Tue, 25 Mar 2008 16:05:27 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: pat cpu feature bit setting for known cpus
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Venki Pallipadi" <venkatesh.pallipadi@intel.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "kernel list" <linux-kernel@vger.kernel.org>, suresh.b.siddha@intel.com
In-Reply-To: <47E9843A.1060702@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803242324.35357.yhlu.kernel@gmail.com>
	 <47E9003B.5010002@zytor.com>
	 <86802c440803251103taf4c8f2mb674c3d17f3c2345@mail.gmail.com>
	 <20080325190851.GC30998@linux-os.sc.intel.com>
	 <20080325200830.GB15330@elte.hu> <47E962AE.9040307@zytor.com>
	 <47E9843A.1060702@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 4:01 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> H. Peter Anvin wrote:
>  > Ingo Molnar wrote:
>  >> * Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:
>  >>
>  >>>>>  OK, note previous question: what is the motivation for having
>  >>>>>  this as a whitelist (as opposed to a blacklist)?
>  >>>> Venkatesh could tell?
>  >>> Main reason for white-list at this point is not to be side-tracked by
>  >>> real or potential erratas on older CPUs. Focussing on getting the
>  >>> support for this feature on current and future CPUs. If older CPUs
>  >>> have survived all these days without this feature, they should be
>  >>> doing OK.
>  >>
>  >> well, the upside would be that since most testing of Linux kernels is
>  >> done on _old_ hardware (people tend to risk their old hw first ;-),
>  >> we'd get faster convergence of the codebase, even though we have the
>  >> risk of erratas (known and unknown ones alike). Code that artificially
>  >> limits its utility is almost always slow to stabilize.
>  >>
>  >
>  > Yes, using a whitelist of this type is wrong, IMO, and smells faintly of
>  > vendor-lockin.
>  >
>
>  By the way, I want to clarify: I didn't mean it was *intended* as
>  vendor-lockin, just that it's an undesirable effect of this.

if the PAT works, we may need to trim the memory according to MTRR, right?

YH
