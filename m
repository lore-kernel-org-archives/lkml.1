Return-Path: <linux-kernel-owner+w=401wt.eu-S1760179AbYF3KAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179AbYF3KAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 06:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbYF3KAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 06:00:42 -0400
Received: from bu3sch.de ([62.75.166.246]:46759 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887AbYF3KAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 06:00:42 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: Drivers for selfmade hardware
Date: Mon, 30 Jun 2008 12:00:18 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel <linux-kernel@vger.kernel.org>
References: <200806292147.52112.mb@bu3sch.de> <20080630095014.GA3211@local>
In-Reply-To: <20080630095014.GA3211@local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806301200.19210.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 June 2008 11:50:15 Hans J. Koch wrote:
> This driver is not only useful for PCI TV cards. With little
> modification, it could be used for bttv chips integrated in embedded
> systems as platform devices. You might have more users than you think
> ;-)

Oh nice. I didn't know that such devices exist. However, these embedded
devices might want to use the original bttv driver and modify that for
generic GPIO support.
This btgpio driver clashes with the bttv driver and the two drivers can't be
used at the same time. That's fine for me, however, as I removed the TV tuner
and more stuff from the card. So I decided to write a stripped-down driver
instead of extending the bttv driver.

But of course, if you still use the card as TV card, we cannot use
all GPIOs for generic GPIOs, as the card uses some of them to communicate
with other chips (That's why I unsoldered the pins). So extending bttv for
generic GPIO support might become hairy with all the different boards with
possibly different GPIO assignments. I didn't want to get into that for now.

But it's nice to know that such devices do exist.

> > 
> > So what's the policy? Push to mainline or keep as seperate
> > patch?
> 
> Definetly mainline. But don't forget to cc: other relevant
> maintainers/lists (v4l, gpio, maybe linux-embedded).

Ok, nice.

-- 
Greetings Michael.
