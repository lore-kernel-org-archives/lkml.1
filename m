Return-Path: <linux-kernel-owner+w=401wt.eu-S1752407AbZKGQhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbZKGQhR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 11:37:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbZKGQhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 11:37:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:38401 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbZKGQhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 11:37:14 -0500
Subject: Re: Intermittent early panic in try_to_wake_up
From: Peter Zijlstra <peterz@infradead.org>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Yinghai Lu <yinghai@kernel.org>
In-Reply-To: <4AF59F24.4010501@gmail.com>
References: <4AE0EBBD.6090005@gmail.com>
	 <1256289781.22979.11.camel@marge.simson.net>  <4AF36364.9090004@gmail.com>
	 <1257485650.6233.17.camel@marge.simson.net>  <4AF4B614.3080708@gmail.com>
	 <1257569157.6390.5.camel@marge.simson.net>  <4AF59F24.4010501@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Nov 2009 17:35:54 +0100
Message-ID: <1257611754.4108.12.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-11-07 at 12:24 -0400, Kevin Winchester wrote:
> Mike Galbraith wrote:
> > On Fri, 2009-11-06 at 19:49 -0400, Kevin Winchester wrote:
> > 
> >> The patch below does not apply to mainline, unless I'm doing something wrong.
> >> It's against -tip, I assume?  Is it just as applicable to mainline?
> > 
> > It was mainline, but I had the scheduler pull request and another in for
> > testing as well.  Linus has pulled, so it'll apply now, with offsets.
> > 
> 
> It did end up applying, but did not have any effect.  Looking at the patch
> again, I see that it appears to only affect CONFIG_SMP, which I am not
> running (and in fact it adds a build warning for the !SMP case).  So there
> was not much chance of it fixing anything, I suppose.
> 
> Any other ideas?  I don't have a serial console, and the trace scrolls off
> my console, so I don't know if any debug printks would help.  Would it help
> if I copied the entire panic message entirely, including the Code section?
> I can try that the next time it happens.

Use vga=ask boot_delay=100 select the highest res possible.

Possibly you could use a digital (video) camera to record the output.

