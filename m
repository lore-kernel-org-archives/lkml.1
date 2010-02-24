Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab0BXGZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 01:25:49 -0500
Received: from ernst.netinsight.se ([194.16.221.21]:64944 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752181Ab0BXGZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 01:25:48 -0500
Date: Wed, 24 Feb 2010 07:25:42 +0100
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: =?ISO-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Cc: linux-kernel@vger.kernel.org, wim@iguana.be, seth.heasley@intel.com
Subject: Re: [PATCH] iTCO_wdt: Don't stop on shutdown with nowayout
Message-ID: <20100224072542.03e5ae08@marrow.netinsight.se>
In-Reply-To: <4B840154.1010501@draigBrady.com>
References: <20100223164019.60a6de1a@marrow.netinsight.se>
	<4B840154.1010501@draigBrady.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Feb 2010 16:24:52 +0000
> > +	if (!nowayout)
> > +		iTCO_wdt_stop();
> >   }
> >
> >   #define iTCO_wdt_suspend NULL
> 
> I see the issue, however what happens if you're
> rebooting into a system that doesn't then renable the watchdog.
> I've seen systems where the hardware watchdog is not reset
> during the reboot process, in which case you'll get a
> reboot while running the other system.

Well, in that case I would run without nowayout. I just think the
behavior is a bit strange if the watchdog is turned off at all if we
have nowayout set.

Thanks for your suggestion though!

// Simon
