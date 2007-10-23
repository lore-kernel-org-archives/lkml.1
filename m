Return-Path: <linux-kernel-owner+w=401wt.eu-S1752761AbXJWUdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbXJWUdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 16:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbXJWUdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 16:33:17 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:43986 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbXJWUdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 16:33:16 -0400
Date: Tue, 23 Oct 2007 22:35:48 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
Message-ID: <20071023203547.GO9748@enneenne.com>
References: <20071023180417.GM9748@enneenne.com> <20071023201750.GE7793@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023201750.GE7793@redhat.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] LinuxPPS - PPS support for Linux
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 04:17:50PM -0400, Dave Jones wrote:
> On Tue, Oct 23, 2007 at 08:04:18PM +0200, Rodolfo Giometti wrote:
> 
> Hi Rodolfo,

Hi! :)

>  > here my last patch for PPS support.
>  > 
>  > Please, let me know if I have something to do for kernel inclusion.
> 
> Thanks for trying to get this merged, we've had a few users asking
> us to support this in the Fedora kernel.

This sounds good! ;)

> >From a quick look through, it doesn't look too bad.
> A couple of obvious things that jumped out..
> 
> * The example program in the Documentation dir.
>   There was some discussion recently about moving away 
>   from doing this, and instead moving code to the samples/ dir
>   (or including it in util-linux instead if applicable).

Mmm, I just consider them as simple userland examples. They don't need
to manage PPS devices.

I can remove them from Documentation/pps/, no problems, but in my
modest opinion they are just documentation. :)

>  > +    static struct pps_source_info_s pps_ktimer_info = {
>  > +            name         : "ktimer",
>  > +            path         : "",
>  > +            mode         : PPS_CAPTUREASSERT | PPS_OFFSETASSERT | \
>  > +			   PPS_ECHOASSERT | \
>  > +                           PPS_CANWAIT | PPS_TSFMT_TSPEC,
>  > +            echo         : pps_ktimer_echo,
>  > +            owner        : THIS_MODULE,
>  > +    };
> 
>   should be
>     .name = "ktimer"
>   etc..

Fixed.

>  > +#include <linux/version.h>
> 
> This should be getting included automatically for you.

Fixed.

> On the whole, asides from these (very) minor nits, quite a clean
> submission compared to a lot of new driver submissions to lkml.
> Might want to run it through scripts/checkpatch.pl too to see
> if that picks up any more minor fluff.

Ok!

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
