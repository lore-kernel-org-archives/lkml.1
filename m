Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478AbXIONoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbXIONoW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 09:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbXIONoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 09:44:16 -0400
Received: from www.osadl.org ([213.239.205.134]:56943 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752481AbXIONoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 09:44:15 -0400
Subject: Re: cpu hotplug support broken in 2.6.23-rc3
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeff Chua <jeff.chua.linux@gmail.com>, rusty@rustycorp.com.au,
       vatsa@in.ibm.com, zwane@arm.linux.org.uk,
       kernel list <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
In-Reply-To: <20070915031858.70a3a331.akpm@linux-foundation.org>
References: <20070827104350.GA2073@elf.ucw.cz>
	 <b6a2187b0708280721w20d5dc44q249642f7946ae55a@mail.gmail.com>
	 <20070903034720.GB3655@ucw.cz> <200709031219.12846.rjw@sisk.pl>
	 <1188822917.3406.0.camel@chaos>
	 <20070904072744.GA30474@atrey.karlin.mff.cuni.cz>
	 <1189713695.3974.23.camel@chaos> <20070914123816.GE1671@elf.ucw.cz>
	 <1189774257.3100.7.camel@chaos> <1189775743.3100.9.camel@chaos>
	 <1189849781.4319.5.camel@chaos>
	 <20070915031858.70a3a331.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 15 Sep 2007 15:44:10 +0200
Message-Id: <1189863850.4319.10.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 (2.11.92-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-09-15 at 03:18 -0700, Andrew Morton wrote:
> On Sat, 15 Sep 2007 11:49:41 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:
>
> I dropped the timekeeping.c hunks because they are an older version of
> timekeeping-prevent-time-going-backwards-on-resume.patch which I already
> had.

Err, no. The timekeeping hunk is redone due to the lockdep fix which I
made.

Thanks,

	tglx


