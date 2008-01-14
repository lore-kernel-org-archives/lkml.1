Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbYANCk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbYANCk0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 21:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbYANCkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 21:40:16 -0500
Received: from home.nigel.suspend2.net ([203.171.70.205]:58117 "EHLO
	server1.example.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753206AbYANCkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 21:40:15 -0500
Message-ID: <478ACB90.3040709@suspend2.net>
Date: Mon, 14 Jan 2008 13:40:16 +1100
From: nigel@suspend2.net
Reply-To: nigel@nigel.suspend2.net
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Pavel Machek <pavel@ucw.cz>, Russell King <rmk+lkml@arm.linux.org.uk>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH: 2/2] [SERIAL] avoid stalling suspend if serial port won't
 drain
References: <20080108115148.GB10546@flint.arm.linux.org.uk>	<20080108115703.GA27179@flint.arm.linux.org.uk>	<20080111101721.GA4463@ucw.cz>	<478A95DB.80407@suspend2.net> <20080114004959.0f533fef@lxorguk.ukuu.org.uk>
In-Reply-To: <20080114004959.0f533fef@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Alan Cox wrote:
>>> Is printk() enough for 'we've just lost your data' condition? Maybe we
>>> should abort suspend if we can't drain fifo?
>> No way. Think about this from a users' perspective. No one wants suspend
>> to ram or hibernate functionality that works sometimes and not others.
>> They want it to work reliably so they don't have to worry about their
>> laptop overheating while they're getting on the bus or airplane.
>> Aborting isn't an option.
> 
> Dumb question on the printk however - what if the port that is sticking
> is the console - don't we recurse and die ?

I don't know, but I'd argue that we shouldn't die. Things should be as
robust as possible.

Regards,

Nigel
