Return-Path: <linux-kernel-owner+w=401wt.eu-S1756710AbYGFKCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbYGFKCw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 06:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752745AbYGFKCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 06:02:43 -0400
Received: from crow.cadsoft.de ([217.86.189.86]:5622 "EHLO raven.cadsoft.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752598AbYGFKCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 06:02:42 -0400
X-Greylist: delayed 1851 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Jul 2008 06:02:42 EDT
Message-ID: <48708BBF.9050400@cadsoft.de>
Date: Sun, 06 Jul 2008 11:09:19 +0200
From: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
Organization: CadSoft Computer GmbH
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
CC: kernelnewbies <kernelnewbies@nl.linux.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jaswinder Singh <jaswinder@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-dvb] [PATCH] Remove fdump tool for av7110 firmware
References: <1214139259.2994.8.camel@jaswinder.satnam> <200807060315.51736@orion.escape-edv.de>
In-Reply-To: <200807060315.51736@orion.escape-edv.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.0 (raven.cadsoft.de [192.168.1.1]); Sun, 06 Jul 2008 11:09:21 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/08 03:15, Oliver Endriss wrote:
> Jaswinder Singh wrote:
>> There's no point in this, since the user can use the BUILTIN_FIRMWARE
>> option to include arbitrary firmware files directly in the kernel image.
> 
> NAK! This option allows to compile the firmware into the _driver_,
> which is very useful if you want to test various driver/firmware
> combinations. Having the firmware in the _kernel_ does not help!

I strongly support Oliver's request!
Working with various driver versions is much easier with the
firmware compiled into the driver!

Klaus

> Well, I am tired to fight for this option in the kernel every other
> month. :-(
> 
> @Mauro:
> Is there a way to strip this stuff from Kconfig/Makefile/av7110*.[ch]
> for submission to the kernel? Basically I don't care whether and how
> they cripple the driver in the kernel. But I would like to keep the code
> 'as is' in the linuxtv repositories.
> 
> CU
> Oliver
