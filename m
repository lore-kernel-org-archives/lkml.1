Return-Path: <linux-kernel-owner+w=401wt.eu-S1755264AbZJRUXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbZJRUXO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 16:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173AbZJRUXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 16:23:14 -0400
Received: from lucidpixels.com ([75.144.35.66]:54745 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755126AbZJRUXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 16:23:13 -0400
Date: Sun, 18 Oct 2009 16:23:17 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: nut-upsuser@lists.alioth.debian.org
cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: 2.6.31.4: USB/UPS connectivity issue on Intel DP55KG Motherboard
 [DEBUG logs included upsd/upsmon/usbhid-ups]
In-Reply-To: <alpine.DEB.2.00.0910140926560.19307@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.0910181619360.27363@p34.internal.lan>
References: <alpine.DEB.2.00.0910131749190.5034@p34.internal.lan> <4AD51C4E.1090204@gmail.com> <alpine.DEB.2.00.0910140359070.15961@p34.internal.lan> <alpine.DEB.2.00.0910140904110.19307@p34.internal.lan>
 <alpine.DEB.2.00.0910140926560.19307@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 14 Oct 2009, Justin Piszcz wrote:

>
>
> On Wed, 14 Oct 2009, Justin Piszcz wrote:
>
>> Hi,
>> 
>> I have included debugging logs-- see below, is this a nut or kernel/USB 
>> subsystem issue?
>> 
>> Robert/Nut User List--
>> 
>> Looks like the data goes stale, please let me know if any more 
>> logs/debugging is required, is this a kernel/usb problem or a nut issue? I 
>> recall a change in the USB subsystem a few kernel versions back caused a 
>> different issue (on a different UPS, but nevertheless it was kernel 
>> related).
>

The details+logs are here (previous e-mail did not go through, too large for
the list):
wget http://home.comcast.net/~jpiszcz/20091014/nut-problem.txt

For now I have disabled nut-- is there any more debugging that I can do to
help find/solve the problem?  Also cc'ing linux-usb & linux-kernel on this 
one.

Highlights from the above txt file:

Pinging UPS [apc]
mainloop: polling 3 filedescriptors
Got PONG from UPS [apc]
mainloop: polling 3 filedescriptors
mainloop: no data available
mainloop: polling 3 filedescriptors
sstate_dead: driver for UPS [apc] says data is stale
Data for UPS [apc] is stale - check driver
mainloop: polling 3 filedescriptors
mainloop: no data available
sstate_dead: driver for UPS [apc] says data is stale
mainloop: polling 3 filedescriptors
Sending error [DATA-STALE] to client 127.0.0.1
write: [destfd=6] [len=15] [ERR DATA-STALE]
sstate_dead: driver for UPS [apc] says data is stale
mainloop: polling 3 filedescriptors
mainloop: no data available
sstate_dead: driver for UPS [apc] says data is stale
mainloop: polling 3 filedescriptors

Entering libusb_get_report
Report[get]: (2 bytes) => 50 16
PhyMax = 0, PhyMin = 0, LogMax = 100, LogMin = 0
get_unit_expo: 00000000 found 0
Path: UPS.PowerConverter.PercentLoad, Type: Feature, ReportID: 0x50, Offset: 0, Size: 8, Value: 22.000000
Entering libusb_get_report
Can't retrieve Report 21: Broken pipe
send_to_one: PONG
upsdrv_updateinfo...
Got to reconnect!

The same cable, UPS etc was used on another motherboard for 1-2+ years without
any issue, after moving it to a DP55KG, this problem began.

Justin.
