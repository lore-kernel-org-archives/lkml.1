Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282AbXICMfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbXICMfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 08:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbXICMfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 08:35:32 -0400
Received: from www.osadl.org ([213.239.205.134]:39954 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752586AbXICMfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 08:35:31 -0400
Subject: Re: cpu hotplug support broken in 2.6.23-rc3
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Jeff Chua <jeff.chua.linux@gmail.com>,
       rusty@rustycorp.com.au, vatsa@in.ibm.com, zwane@arm.linux.org.uk,
       kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <200709031219.12846.rjw@sisk.pl>
References: <20070827104350.GA2073@elf.ucw.cz>
	 <b6a2187b0708280721w20d5dc44q249642f7946ae55a@mail.gmail.com>
	 <20070903034720.GB3655@ucw.cz>  <200709031219.12846.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 03 Sep 2007 14:35:17 +0200
Message-Id: <1188822917.3406.0.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-03 at 12:19 +0200, Rafael J. Wysocki wrote:
> > Ok, so it gets weirder. I have now machine in "hung" state; other
> > consoles still work, but there are no timers -  sleep 1 hangs forever.
> > 
> > sysrq-t shows kstopmachine hung in hrtimer_try_to_cancel.
> > 
> > So I indeed suspect difference-in-kconfig to trigger this, and will
> > try disabling noidlehz.
> 
> I would unset CONFIG_HIGH_RES_TIMERS for starters.
> 
> Well, I guess Thomas should know about that. ;-)

What was the last known to work version ?

	tglx


