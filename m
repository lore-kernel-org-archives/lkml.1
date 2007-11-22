Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbXKVVWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbXKVVWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 16:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbXKVVW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 16:22:26 -0500
Received: from fmmailgate05.web.de ([217.72.192.243]:49808 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbXKVVWZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 16:22:25 -0500
Date: Thu, 22 Nov 2007 22:22:23 +0100
Message-Id: <1761125@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Clemens Koller <clemens.koller@anagramm.de>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       Simon Arlott <simon@fire.lp0.eu>
Subject: Re: System reboot triggered by just reading a device file....!?
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/b5PixrETkvC1BX3eykmD+EqsGmVYv6FRCteMWarfGsn4JI
 gFJd1wc0HTkdHCh8wfDzcxiYiYLLNnSCHVssqENGmCVbid9xIc=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Clemens, 

thanks, but i know i could do this.

this thread is not meant to protect myself from this curiousity but it is meant to protect others.
it`s a trap. 
i stepped into that.
now i know that trap, so i can easily sidestep.

but most people using linux don`t know about the watchdog, so i don`t think they will know about this trap. 
you can`t make that become common knowledge.

and we can`t expect that they will find out _what`s_ the trap at all, if they step into.
having this behaviour documented is like putting a sign "don`t step into this" at the back of the trap 

so why shouldn`t we help them avoiding it ?

it maybe very seldom that someone steps into this. 
but it may happen and then someone will have trouble and spend time on this.
i think every admin can tell you about weird random reboots of his systems which he cannot explain what was the reason for it.
this maybe some of those reasons and this one could be avoided. 
i`m thinking of something simple like echo "now you`re armed" > /dev/watchdog

regards
roland


> -----Ursprüngliche Nachricht-----
> Von: "Clemens Koller" <clemens.koller@anagramm.de>
> Gesendet: 22.11.07 21:43:15
> An: devzero@web.de
> CC: Simon Arlott <simon@fire.lp0.eu>, Robert Hancock <hancockr@shaw.ca>,  linux-kernel@vger.kernel.org
> Betreff: Re: System reboot triggered by just reading a device file....!?


> 
> devzero@web.de schrieb:
> 
>  > [was: reading /dev/watchdog triggers reboot as intended]
>  > need to change my own philosophy now, because i learned that reading isn`t harmless.   ;)
> 
> If you want to protect you from your curiosity (or from reading anything),
> you could just disable the watchdog in the kernel.
> See: Device Drivers -> Character devices -> Watchdog Timer Support -> ...
> 
> Regards,
> -- 
> Clemens Koller
> __________________________________
> R&D Imaging Devices
> Anagramm GmbH
> Rupert-Mayer-Straße 45/1
> Linhof Werksgelände
> D-81379 München
> Tel.089-741518-50
> Fax 089-741518-19
> http://www.anagramm-technology.com
> 


______________________________________________________________________________
Jetzt neu! Im riesigen WEB.DE Club SmartDrive Dateien freigeben und mit 
Freunden teilen! http://www.freemail.web.de/club/smartdrive_ttc.htm/?mc=021134

