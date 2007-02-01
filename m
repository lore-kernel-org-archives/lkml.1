Return-Path: <linux-kernel-owner+w=401wt.eu-S1030588AbXBAPT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030588AbXBAPT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 10:19:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161164AbXBAPT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 10:19:28 -0500
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:41149
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030588AbXBAPT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 10:19:27 -0500
Message-ID: <45C204F7.9060303@microgate.com>
Date: Thu, 01 Feb 2007 09:19:19 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 1.5.0.8 (Windows/20061025)
MIME-Version: 1.0
To: Aubrey Li <aubreylee@gmail.com>
CC: Tosoni <jp.tosoni@acksys.fr>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [BUG]: 2.6.19.2: Weird serial core issue
References: <6d6a94c50701311833m5952c6fdn8e1f0db28d674e79@mail.gmail.com>	 <000201c745d9$4577fe20$2e01a8c0@acksys.local> <6d6a94c50702010238p7866f5a5m8824d2ca518eb704@mail.gmail.com>
In-Reply-To: <6d6a94c50702010238p7866f5a5m8824d2ca518eb704@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Aubrey Li wrote:
> But When I type "ENTER" key,
> 
> I got
> ------------
> cflag = 0x1cb1, old = 0x80001cb1
> cflag = 0x1cb1, old = 0x1cb1
> ------------
> That means terminal setting is back to crtscts disabled. But here I
> didn't do anything to disable it, I just type "ENTER", crtscts setting
> should keep enabled. What makes it back to disabled? Now I guess there
> must be something wrong with serial core.

Is there an mgetty or similar program monitoring
the same serial port?

-- 
Paul Fulghum
Microgate Systems, Ltd.
