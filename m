Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487AbYGVNcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbYGVNcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 09:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbYGVNb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 09:31:58 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:41995 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750845AbYGVNb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 09:31:58 -0400
Message-ID: <4885E13E.1010607@euromail.se>
Date: Tue, 22 Jul 2008 15:31:42 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, robfitz@273k.net,
       akpm@osdl.org, Vojtech Pavlik <vojtech@suse.cz>, dmonakhov@openvz.org
Subject: Re: [PATCH] hid: wellspring device quirks
References: <1215963466.12757.0.camel@alnilam> <alpine.LNX.1.10.0807221504380.3037@jikos.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0807221504380.3037@jikos.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.35.11
X-Scan-Result: No virus found in message 1KLHy8-0004mK-9A.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1KLHy8-0004mK-9A 6971a6b23caec8df026a28f79da040f9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Sun, 13 Jul 2008, Henrik Rydberg wrote:
> 
>> This patch adds the HID_QUIRK_IGNORE_MOUSE quirk for the Apple USB
>> multitouch devices based on BCM5974, aka Wellspring. These devices
>> will instead be picked up by the new bcm5974 driver.
> 
> Hi Henrik,
> 
> is the mouse not working at all with standard HID driver?
> 

Yes, it is working out-of-the-box, only poorly.

> I'd prefer to postpone merging this patch until bcm5974 hits mainline if
> the device works in a limited way with standard HID driver, so that we
> don't introduce regression.
> 

Absolutely, this patch should be applied together with the bcm5974 driver,
or not be applied. The driver patch is here:

http://userweb.kernel.org/~akpm/mmotm/broken-out/input-bcm5974-055-smoother-motion-irq-simplification.patch

> If the device doesn't work with HID driver at all though, it is probably
> perfectly fine to merge it right away. Please let me know, I have no
> knowledge about this particular device.

It is fine to leave it, but I would of course prefer to have the driver included together with this patch.

Thanks!
Henrik Rydberg

