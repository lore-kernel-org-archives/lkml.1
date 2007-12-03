Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbXLCOMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbXLCOMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 09:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbXLCOM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 09:12:29 -0500
Received: from mail.gmx.net ([213.165.64.20]:40545 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752087AbXLCOM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 09:12:28 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/wPIhYsfTwCG2FX8c9r0k1+iY67T6pCXj3bSA24w
	LK1RE169X4LqUQ
Message-ID: <47540EC8.9080401@gmx.de>
Date: Mon, 03 Dec 2007 15:12:24 +0100
From: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Daniel Drake <dsd@gentoo.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: hibernation issue with kernel 2.6.23-gentoo-r3 at T41
References: <200712031419.41596.toralf.foerster@gmx.de> <47540950.4090207@gentoo.org>
In-Reply-To: <47540950.4090207@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Drake schrieb:
> And the outcome was what exactly? It didn't suspend, and hard-hung? Or 
> didn't suspend, came back to a usable system? ...
Ah, sorry - the system came back and  I could continue my work.
However I couldn't hibernate my system (I tried it 2 additional times) 
as long as
my user mode linux image was running (2.6.23 UML kernel). Within UML I 
ran cupsd to which firefox
was trying to make a connection. Firefox itself was waiting for a 
response of the cupsd server,
the cupsd itself was generating the ssl -files under /etc/cupsd/ssl as 
far as I could read from the cupsd log.
> Did you press alt+sysrq+T or did all this come about as a result of 
> the suspend?
I pressed <Fn>+<F12> to hibernate the system, and b/c the scrren was 
black and came back some secs later I had have a look into
/var/log/message and copied the outout into my first mail.

