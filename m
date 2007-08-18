Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbXHRKVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbXHRKVR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 06:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbXHRKVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 06:21:05 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:30901 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbXHRKVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 06:21:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NezdiJeci0e6lNAZJjxToBA3J0o/gEuNRyHUGner6BlIM3/lfJ5Ak6fOWdS+5Bbxz6O4qjb75wxK7pazPQx/YvEcBRi+uk6eTaU+xYJJtCo+aX6Y6o6ZcrqYFFb09lKLajzsVUJiQrmMv2AzLszCb/RtXw3dnIKMZxKqJ2PnLZU=
Message-ID: <ab40e9c0708180321k6415c454v35a0b00fd050f570@mail.gmail.com>
Date: Sat, 18 Aug 2007 12:21:01 +0200
From: "Xu Yang" <risingsunxy@googlemail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: kernel 2.6.19 porting
Cc: "Willy Tarreau" <w@1wt.eu>, linux-kernel@vger.kernel.org
In-Reply-To: <46C6C2D5.205@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ab40e9c0708170924h5b958423jcd0e82e211ca8463@mail.gmail.com>
	 <20070818052805.GO6002@1wt.eu> <46C6C2D5.205@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Willy ,

thanks for your reply.

I am sure that my timer is working( TIMER0_1), because I checked the
register , it was counting , and the interrupt flag register also
gives out interrupts periodicly.
the problem is that it seems that the program just toggles here:
interrupt rountines, gic_ack(), interrupt handle
functions.............., my simulation enviorment also tells me that
invalid iqr id (0x21) is writen to EOI(end of interrupt).
I am also sure in the interrupt routine I clean the interrupt flag of the timer.

so this is roughly my situation.

does anyone have some idea?

thanks,

regards,

yang


2007/8/18, Stefan Richter <stefanr@s5r6.in-berlin.de>:
> Willy Tarreau wrote:
> > On Fri, Aug 17, 2007 at 06:24:17PM +0200, Xu Yang wrote:
> >> I have built up a software virtual prototype system with ARM11MPCORE.
> >> my system is similar with realview_eb_mpcore. but my system is
> >> simpler, which has only a mpcore , uart0, console,timer0_1, and
> >> memorys.
> >>
> >> I want to run kernel 2.6.19 on it.
> ...
> > If you upgrade to a more recent kernel (eg: 2.6.22), you'll get
> > more feedback because it's fresher in people's mind.
>
> Also, newer kernels apparently have updates which are relevant to EB MPCore.
> --
> Stefan Richter
> -=====-=-=== =--- =--=-
> http://arcgraph.de/sr/
>
