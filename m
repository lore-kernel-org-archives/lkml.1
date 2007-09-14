Return-Path: <linux-kernel-owner+w=401wt.eu-S1761338AbXINNP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761338AbXINNP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 09:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758799AbXINNPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 09:15:46 -0400
Received: from www.osadl.org ([213.239.205.134]:38945 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756768AbXINNPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 09:15:45 -0400
Subject: Re: cpu hotplug support broken in 2.6.23-rc3
From: Thomas Gleixner <tglx@linutronix.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Chua <jeff.chua.linux@gmail.com>,
       rusty@rustycorp.com.au, vatsa@in.ibm.com, zwane@arm.linux.org.uk,
       kernel list <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
In-Reply-To: <1189774257.3100.7.camel@chaos>
References: <20070827104350.GA2073@elf.ucw.cz>
	 <b6a2187b0708280721w20d5dc44q249642f7946ae55a@mail.gmail.com>
	 <20070903034720.GB3655@ucw.cz> <200709031219.12846.rjw@sisk.pl>
	 <1188822917.3406.0.camel@chaos>
	 <20070904072744.GA30474@atrey.karlin.mff.cuni.cz>
	 <1189713695.3974.23.camel@chaos>  <20070914123816.GE1671@elf.ucw.cz>
	 <1189774257.3100.7.camel@chaos>
Content-Type: text/plain
Date: Fri, 14 Sep 2007 15:15:43 +0200
Message-Id: <1189775743.3100.9.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 (2.11.92-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-14 at 14:50 +0200, Thomas Gleixner wrote:
> Pavel,
> 
> On Fri, 2007-09-14 at 14:38 +0200, Pavel Machek wrote:
> > > I have an yet untested fix, which preserves the broadcast state across
> > > the offline state, but Len is looking into it as well, whether we can
> > > just reevaluate the power states (and the broadcast flags) when a cpu
> > > becomes online again. If Len can do that easily for 2.6.23, I'd prefer
> > > that.
> > 
> > Is there a patch you want me to test? Or does Len have anything to
> > play with?
> 
> Venki sent me an initial patch, but it has issues with the notify
> ordering. Find below my "cache the broadcast flags" version for testing.

Hmmpf, the flag is still cleared when the cpu goes offline. Need to take
a closer look.

	tglx


