Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbYBQWJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbYBQWJy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 17:09:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbYBQWJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 17:09:43 -0500
Received: from rtr.ca ([76.10.145.34]:1433 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbYBQWJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 17:09:43 -0500
Message-ID: <47B8B0A3.2070005@rtr.ca>
Date: Sun, 17 Feb 2008 17:09:39 -0500
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: What's needed for a PCIe card to be recognized?
References: <20080216225932.22460d31@dilbert.local>	<20080216143946.6d532a41@laptopd505.fenrus.org>	<20080217015453.2a4e4142@dilbert.local>	<20080216182939.061c7246@laptopd505.fenrus.org>	<20080217133753.661cd98d@bluebox.local>	<20080217072927.4b6c5964@laptopd505.fenrus.org> <20080217174728.76e4231a@bluebox.local> <47B8AFAA.30101@rtr.ca>
In-Reply-To: <47B8AFAA.30101@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Hans J. Koch wrote:
..
>> Really? Unbelievable what these guys do to make my live harder...
>> So, they might use some undocumented GPIO to turn the power on, and
...

GPIO lines are not usually very difficult to trace,
and programming them is pretty easy, too ...

If I had an EeePC here, I'd do that for you (and everyone else),
but I'm waiting for a lower-power (fanless) unit to be introduced first.

>> refuse that if they don't find the original card? Looks like I can't
>> have WLAN on an EeePC (I won't run a tainted kernel). Stupid thing to
>> sell a PC with Linux preinstalled but with hardware not supported in
>> mainline.
> ..
> 
> Try it again with 2.6.25-rc2 and this module option:
> 
>    options pciehp pciehp_force=1
> 
> Just a thin hope, really, but it might work.
