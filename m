Return-Path: <linux-kernel-owner+w=401wt.eu-S1761819AbXGQANV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761819AbXGQANV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 20:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754688AbXGQANN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 20:13:13 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:50904 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbXGQANM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 20:13:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=IJ4taP+Cobuom0oZEgjeMreV4oyFYEZmu1wxsmV/hQiLd6CqG+H01sInq+DdBRlrGxnll8mmg+PP1W0CcdKKapXK6p5op9G5u6VTADgSgTLd8otkiz6SLASCJ0eu1XYnI0vzbqFHWoDwSuCp3jAq2dnYk8q08FDkmv/7uEihuMI=
Date: Mon, 16 Jul 2007 20:12:39 -0400
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
Cc: david@lang.hm, Joseph Fannin <jfannin@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: Hibernating To Swap Considered Harmful
Message-ID: <20070717001239.GB20082@nineveh.local>
Mail-Followup-To: Jeremy Maitin-Shepard <jbms@cmu.edu>, david@lang.hm,
	Joseph Fannin <jfannin@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	"Huang, Ying" <ying.huang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
	linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <200707121453.49616.rjw@sisk.pl> <Pine.LNX.4.64.0707121150460.25614@asgard.lang.hm> <200707122134.29991.rjw@sisk.pl> <Pine.LNX.4.64.0707121953440.25614@asgard.lang.hm> <20070713054244.GA20082@nineveh.local> <Pine.LNX.4.64.0707122250170.25614@asgard.lang.hm> <20070713062039.GA29055@nineveh.local> <Pine.LNX.4.64.0707122319270.25614@asgard.lang.hm> <20070713071512.GB29055@nineveh.local> <87odig1idx.fsf@jbms.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87odig1idx.fsf@jbms.ath.cx>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: jfannin@gmail.com (Joseph Fannin)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 10:35:22AM -0400, Jeremy Maitin-Shepard wrote:
> jfannin@gmail.com (Joseph Fannin) writes:
>
> There is a very simple solution to this obscure problem: (if I
> understand correctly, you want to dual boot Mac OS X and Linux (and
> maybe also Windows?))
>
> use LVM, thus allowing you to have as many volumes as you like in the
> partition

Ok.

Why are all these workarounds preferred, instead of proper suspend
support for swap files?

IOW, what reasons are there to *not* support swap files, other than the
hit-and-miss Linux suspend support?

I brought up the swap file issue to illustrate that writing
hibernation images to files needs to be supported anyway.  Once you
have that, there is no good reason to write the hibernation image to
swap, and several reasons not to.

That my particular problem might be messily worked around isn't really
important in the context of that argument, which no one has responded
to.

(Aside from adding more administrivia to my Macintosh's setup, your
LVM suggestion would prevent the ext3 drivers for Windows and OS X
from working, as they don't do LVM.  This is arguably not Linux's
problem -- but Linux *already supports* a working solution).

--
Joseph Fannin
jfannin@gmail.com

