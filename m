Return-Path: <linux-kernel-owner+w=401wt.eu-S1757553AbYBUHnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553AbYBUHnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 02:43:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbYBUHmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 02:42:54 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:47829 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbYBUHmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 02:42:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=lcUZuZya58saI7W2ayOmWg9w0CNuPwwISGxs2909+osOSp85SjdhyL0APFdywJMTqeGOsMwwD5ICQhGrMOthKjhOrrRkIt0NtgmAxibma1YBxJXQBvfB97pw59SVLRbR2HGB51ObxNK7X4rDZoznAHPf6fgPvEP4nJbjXbwGKHQ=
Date: Thu, 21 Feb 2008 07:43:46 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org
Subject: Re: [BUG?] APM is hidden in menuconfig
Message-ID: <20080221074346.GA3919@ff.dom.local>
References: <20080220120828.GD3885@ff.dom.local> <200802210123.44367.rjw@sisk.pl> <E1JS02I-0003gO-Py@faramir.fjphome.nl> <200802210221.52765.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802210221.52765.rjw@sisk.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 02:21:52AM +0100, Rafael J. Wysocki wrote:
> On Thursday, 21 of February 2008, Frans Pop wrote:
> > Rafael J. Wysocki wrote:
> > > On Wednesday, 20 of February 2008, Jarek Poplawski wrote:
> > >> So, has it to be so hard? It seems not - at least in good old times...
> > > 
> > > Something in APM uses some code from drivers/base/power/main.c that
> > > depends on PM_SLEEP.
> > 
> > Sure, but that does not make Jarek's point invalid. From a user PoV APM is a
> > high-level configuration option. That is what he wants.
> > It should thus be easily accessible and not be buried beneath a lot of
> > other, much more technical, options.

Probably Frans is right: this should be my point... But I'm not so
"greedy", and I would be happy if it were at least more visible. It
simply seems to me quite not obvious to even think about turning
SUSPEND on when I have problems with a basic acpi function.

Even more interesting question is why this APM or PM_SLEEP dependency
on SUSPEND (or HIBERNATION) isn't visible with "/" searching: PM_SLEEP
looks like some "hidden" option - that's why I tried first to find some
comment in arch/ instead of simply reading Kconfig.

> > Could this maybe be solved by making APM automatically 'select' some options
> > instead of 'depending' on them?
> 
> That, unfortunately, doesn't work.
> 
> IMO the solution might be to separate the APM suspend code from the rest of the
> APM code and make it depend on (PM_SUSPEND && APM).

...Or at least to mention APM in SUSPEND title and description.
Actually, this is really strange: both SUSPEND and PM_SLEEP have
default = y. So it seems they are intended to be more "advertised"
than they are?

Thanks & regards,
Jarek P.
