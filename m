Return-Path: <linux-kernel-owner+w=401wt.eu-S1754890Ab0AZSwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab0AZSwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 13:52:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754717Ab0AZSwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 13:52:37 -0500
Received: from smtp.nokia.com ([192.100.105.134]:53302 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab0AZSwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 13:52:36 -0500
Date: Tue, 26 Jan 2010 20:50:26 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext David Brownell <david-b@pacbell.net>
Cc: "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [RFC/PATCH 1/5] usb: otg: add notifier support
Message-ID: <20100126185026.GB20049@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <6ed0b2680912101251jeec28e6i216dfc51caab13aa@mail.gmail.com>
 <201001260535.21689.david-b@pacbell.net>
 <20100126141443.GE10690@nokia.com>
 <201001260721.29275.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201001260721.29275.david-b@pacbell.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 26 Jan 2010 18:52:04.0163 (UTC) FILETIME=[A6B68130:01CA9EB8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 04:21:28PM +0100, ext David Brownell wrote:
>On Tuesday 26 January 2010, Felipe Balbi wrote:
>> >
>> >Thing is, supplying current is a bit more involved.  If the
>> >board can't supply 300 mA, the USB configuration selection
>> >mechanism has to know that, so it never selects peripheral
>> >configurations which require that much current.
>>
>> but that's done already by the usb core, no ? It rules out configuration
>> based on the hub->power_budget (can't remember if the field is that
>> exact name).
>
>Yes, it handles that ... but where does the power budget
>come from?  That's what I meant by "more involved".

we set it from board-files (on ARM, at least). It's a board 
characteristic, no ?

>As in, the host/supplying side of the power equation can't
>be event driven like the peripheral/consuming side can.
>
>And that's another reason I think it's best to fully solve
>the common (peripheral, recharge-that-batter) case first.

fair enough.

-- 
balbi
