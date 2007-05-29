Return-Path: <linux-kernel-owner+w=401wt.eu-S1759230AbXE2O5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230AbXE2O5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 10:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbXE2O5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 10:57:12 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924AbXE2O5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 10:57:10 -0400
Date: Tue, 29 May 2007 07:55:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Romano Giannetti <romanol@upcomillas.es>
cc: Matthew Garrett <mjg59@srcf.ucam.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Chris Wright <chrisw@sous-sol.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
In-Reply-To: <1180427492.21686.9.camel@localhost>
Message-ID: <alpine.LFD.0.98.0705290752190.26602@woody.linux-foundation.org>
References: <1180008394.15600.26.camel@localhost> 
 <alpine.LFD.0.98.0705270924310.26602@woody.linux-foundation.org> 
 <20070527164300.GA20355@srcf.ucam.org> <200705272032.15971.rjw@sisk.pl> 
 <20070527184402.GA21161@srcf.ucam.org>
 <1180427492.21686.9.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 May 2007, Romano Giannetti wrote:
>
> - The good (?) news. I have made 7 suspend/resume cycle (to ram, I
> haven't tested hibernation) with a 2.6.21.2 with that patch, applied
> manually. The system did suspend and resume nicely even compiling a
> kernel and opening openoffice. Normally (le me stress _normally_) no
> delay was apparent on resume. I do not know how dangerous is this... :-)
> 
> - The bad (?) news. One time out of 7 I had the 60 seconds delay.

Interesting. If you can re-create it, please do the sysrq-T thing again, 
to see what's up. (Also, you might do "sysrq-p", which gives the current 
process data, which sysrq-T does not).

			Linus
