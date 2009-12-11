Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbZLKM6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbZLKM6G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 07:58:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbZLKM6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 07:58:01 -0500
Received: from smtp.nokia.com ([192.100.122.230]:46581 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbZLKM6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 07:58:00 -0500
Date: Fri, 11 Dec 2009 14:57:12 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: "Krogerus Heikki (EXT-Teleca/Helsinki)" 
	<ext-heikki.krogerus@nokia.com>
Cc: "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [RFC/PATCH 4/5] usb: musb: isp1704: add registers from isp1704
Message-ID: <20091211125712.GG12526@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <6ed0b2680912101251jeec28e6i216dfc51caab13aa@mail.gmail.com>
 <1260531086-23857-5-git-send-email-felipe.balbi@nokia.com>
 <4B223C78.2060908@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <4B223C78.2060908@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 11 Dec 2009 12:57:26.0087 (UTC) FILETIME=[7CFD4570:01CA7A61]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 01:35:04PM +0100, Krogerus Heikki (EXT-Teleca/Helsinki) wrote:
>Balbi Felipe (Nokia-D/Helsinki) wrote:
>> transceiver used on RX-51 board.
>>
>> NYET-Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
>> ---
>>
>
>There are now many ULPI transceivers in use. Let's add the global ULPI
>register definitions. isp170x transceivers have only one vendor-specific
>register. The Power Control.

proof-of-concept, that's why it's NYET-Signed-off-by. It was easier to 
just copy the code from our working version for now, but sure, we have 
to do it in some way that works for everybody. I was thinking that 
RX-51's board files could provide us a charger_detect() implementation
which we can use here.

then:

if (!musb->charger_detect)
	return NOTIFY_DONE;

-- 
balbi
