Return-Path: <linux-kernel-owner+w=401wt.eu-S934436AbZLMBuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934436AbZLMBuw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934394AbZLMBut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:50:49 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43568 "HELO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934357AbZLMBur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:50:47 -0500
Date: Sat, 12 Dec 2009 18:34:10 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Balbi <felipe.balbi@nokia.com>
Cc: ext sai pavan <saipavan.243@gmail.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Brownell <dbrownell@users.sourceforge.net>
Message-ID: <20091212183410.GF3092@sirena.org.uk>
References: <6ed0b2680912101251jeec28e6i216dfc51caab13aa@mail.gmail.com>
 <1260531086-23857-3-git-send-email-felipe.balbi@nokia.com>
 <c60a9cb0912110922g10fd0cc7m3b3430731db5ed81@mail.gmail.com>
 <20091211204014.GA30776@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091211204014.GA30776@nokia.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.240.126
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC/PATCH 2/5] usb: otg: twl4030: add support for notifier
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 10:40:14PM +0200, Felipe Balbi wrote:

> that's a threaded irq. Maybe we should patch all twl children to use
> request_threaded_irq() already. I'll test that tomorrow.

You should also now be able to do all the interrupt handling with genirq
without the lockdep dodges that used to be be required.
