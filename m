Return-Path: <linux-kernel-owner+w=401wt.eu-S1754481Ab0AZOcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab0AZOcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 09:32:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458Ab0AZOcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 09:32:10 -0500
Received: from smtp.nokia.com ([192.100.122.230]:28773 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab0AZOcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 09:32:08 -0500
Date: Tue, 26 Jan 2010 16:30:05 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Oliver Neukum <oliver@neukum.org>
Cc: "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       ext David Brownell <david-b@pacbell.net>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [RFC/PATCH 1/5] usb: otg: add notifier support
Message-ID: <20100126143005.GI10690@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <6ed0b2680912101251jeec28e6i216dfc51caab13aa@mail.gmail.com>
 <201001260535.21689.david-b@pacbell.net>
 <20100126141443.GE10690@nokia.com>
 <201001261524.49661.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <201001261524.49661.oliver@neukum.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 26 Jan 2010 14:31:47.0734 (UTC) FILETIME=[4A988B60:01CA9E94]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 03:24:49PM +0100, ext Oliver Neukum wrote:
>Am Dienstag, 26. Januar 2010 15:14:43 schrieb Felipe Balbi:
>> >There are load bursting issues too.  All part of the USB spec;
>> >a load that's OK for 1 millisecond might not be OK for 1 second.
>>
>> if you get a SetConfiguration(config), then you can use that load for as
>> long as needed, the limitation is when not enumerated, afaict.
>
>And when suspended.

but when suspended, we have to cut power ASAP. If not enumerated we can 
still draw power for a few miliseconds due to dead battery provision.

-- 
balbi
