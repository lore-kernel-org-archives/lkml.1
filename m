Return-Path: <linux-kernel-owner+w=401wt.eu-S1753821AbYKAXU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbYKAXU2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 19:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbYKAXUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 19:20:21 -0400
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:4137 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbYKAXUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 19:20:20 -0400
Message-ID: <490CE432.5040005@shikadi.net>
Date: Sun, 02 Nov 2008 09:20:18 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.8.1.16) Gecko/20080727 Thunderbird/2.0.0.16 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: Can you use the USB HID interface within a driver?
References: <490C4133.30400@shikadi.net> <alpine.LRH.1.10.0811012122250.19257@twin.jikos.cz>
In-Reply-To: <alpine.LRH.1.10.0811012122250.19257@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For 2.6.28, the HID code has been completely refactored, and converted 
> into a proper bus, making it possible to write driver easily in a way that 
> the driver implements only parts where device deviates from the HID 
> standard, and lets the rest to be handled by generic code. I guess this is 
> what you are looking for?

Yes, that sounds like exactly what I'm after!  This device seems to be 
HID with a custom protocol over the top, so presumably I can let the HID 
driver handle all the USB initialisation and just focus on the protocol.

> Please look at drivers/hid in 2.6.28-rc1 or newer. There are quite a 
> couple of drivers already using this new infrastructure.

Great, I'll have a look now - thanks!

> If you have any further questions, I'll be happy to help you, but I will 
> be completely offline until 11th November, sorry.

Thanks for that!  I'll see how I go.  If there are existing drivers I 
can use as examples, hopefully I should be okay for the most part.

Cheers,
Adam.

