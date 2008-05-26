Return-Path: <linux-kernel-owner+w=401wt.eu-S1755198AbYEZQae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbYEZQae (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 12:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbYEZQa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 12:30:26 -0400
Received: from smtp-02.mandic.com.br ([200.225.81.133]:47412 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbYEZQaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 12:30:25 -0400
Message-ID: <483AE59A.9080700@diamondcut.com.br>
Date: Mon, 26 May 2008 13:30:18 -0300
From: "Renato S. Yamane" <yamane@diamondcut.com.br>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, 481493@bugs.debian.org
Subject: Re: [Bug 10797] Something is consuming power after shutdown
References: <483AB443.6020807@diamondcut.com.br> <20080526084458.6acce426@infradead.org>
In-Reply-To: <20080526084458.6acce426@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> "Renato S. Yamane" wrote:
>> <http://bugzilla.kernel.org/show_bug.cgi?id=10797>
>> <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=481493>
>>
>> After poweroff, something still working and consuming power. So I
>> loss ~4% of my battery charge in each 12h.
> 
> the most obvious cause could be Wake-on-Lan, that leaves a part of the
> system active (specifically, the network card). With the "ethtool"
> program you can queary and set the state of this.

My network card have option WOL "disabled"

# ethtool eth0 | grep Wake
         Supports Wake-on: pg
         Wake-on: d

> Similarly, but less likely, there is wake-on-serial and wake-on-usb, in
> theory those are possible too but I've yet to see one of those on any
> of my machines.

My laptop don't have serial port and wake-on-usb is disabled too:

# cat /proc/acpi/wakeup
Device  S-state   Status   Sysfs node
LID0      S4    *enabled
RP01      S4     disabled  pci:0000:00:1c.0
RP02      S4     disabled  pci:0000:00:1c.1
RP03      S4     disabled
RP04      S4     disabled
USB1      S0     disabled  pci:0000:00:1d.0
USB2      S0     disabled  pci:0000:00:1d.1
USB3      S0     disabled  pci:0000:00:1d.2
USB4      S0     disabled  pci:0000:00:1d.3
USB7      S0     disabled  pci:0000:00:1d.7
MODM      S4     disabled  pci:0000:00:1e.3
PS2K      S4     disabled  pnp:00:07

Best regards,
Renato S. Yamane
