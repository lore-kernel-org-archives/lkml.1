Return-Path: <linux-kernel-owner+w=401wt.eu-S1751247AbXBZLlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247AbXBZLlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 06:41:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbXBZLlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 06:41:40 -0500
Received: from tim.rpsys.net ([194.106.48.114]:54072 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbXBZLlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 06:41:39 -0500
Subject: Re: 2.6.21-rc1 dims my LCD
From: Richard Purdie <rpurdie@rpsys.net>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0702260154460.10496@twin.jikos.cz>
References: <Pine.LNX.4.64.0702260154460.10496@twin.jikos.cz>
Content-Type: text/plain
Date: Mon, 26 Feb 2007 11:41:30 +0000
Message-Id: <1172490091.5824.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2007-02-26 at 01:59 +0100, Jiri Kosina wrote:
> 2.6.21-rc1 on my ibm t42p dims a LCD after some time (I guess it happens 
> at the time the console should normally be blanked). 
> 
> When I hit the keyboard, the brightness stays low (it's 50% of light or 
> so, so I could read what's on the screen, but it's uncomfortably dim), and 
> I have to manually raise the brightness on the LCD. Quite annoying :)
>
> I have bisected this to your commit 
> 994efacdf9a087b52f71e620b58dfa526b0cf928

Which framebuffer driver and backlight driver are you using?
("ls /sys/class/backlight/" will show which backlight it is)

Is the machine in active use when it dims or at idle and does the screen
blank at the same time it dims? If so, does the keypress unblank the
screen (but not change the brightness)? 

Also, is this on a console or under something like X? 

Thanks,

Richard

