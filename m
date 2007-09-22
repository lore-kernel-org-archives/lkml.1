Return-Path: <linux-kernel-owner+w=401wt.eu-S1750927AbXIVXcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750927AbXIVXcy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 19:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbXIVXcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 19:32:47 -0400
Received: from www.osadl.org ([213.239.205.134]:52096 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751379AbXIVXcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 19:32:47 -0400
Subject: Re: [PATCH] usb-gadget-ether: Prevent oops caused by error
	interrupt  race -V2 (comments update)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Brownell <david-b@pacbell.net>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, bene@linutronix.de,
       akpm@osdl.org
In-Reply-To: <20070922205333.EEA972300C1@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
References: <1190299611.3481.34.camel@chaos>
	 <200709211508.42968.david-b@pacbell.net> <1190482861.4035.59.camel@chaos>
	 <20070922191806.A2F59C2308@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	 <1190489440.4035.103.camel@chaos>
	 <20070922201450.EB20823974D@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	 <1190492580.4035.116.camel@chaos>
	 <20070922205333.EEA972300C1@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Content-Type: text/plain
Date: Sun, 23 Sep 2007 01:32:45 +0200
Message-Id: <1190503965.4035.138.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-09-22 at 13:53 -0700, David Brownell wrote:
> > Sigh. I need a real deep look inside that code to understand, why
> > tx_reqs is not a requestlist but a freelist. Very intuitive naming :)
> 
> It *is* a list of requests:  free ones -- the only kind this level of
> driver is allowed to remember!  ;)
> 
> Yeah, I had to go back and read the driver again before I understood
> just what problem this patch was trying to fix.  Which is why I wanted
> to make sure the mismatch between comments and contents was resolved.

Fair enough. Thanks for sanitizing the comments.

	tglx


