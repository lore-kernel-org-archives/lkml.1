Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1754592AbYLQN1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbYLQN1X (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 08:27:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbYLQN1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 08:27:09 -0500
Received: from co203.xi-lite.net ([149.6.83.203]:60786 "EHLO co203.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbYLQN1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 08:27:08 -0500
Message-ID: <4948FE26.90907@parrot.com>
Date: Wed, 17 Dec 2008 14:27:02 +0100
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-serial@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        linux-kernel@vger.kernel.org
Subject: Re: s3c24xx : TIOCM_CTS handling problem
References: <48D242DC.30102@parrot.com>	<4947B065.5080405@parrot.com> <20081216141533.7bcc5c9b@lxorguk.ukuu.org.uk>
In-Reply-To: <20081216141533.7bcc5c9b@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 17 Dec 2008 13:28:00.0145 (UTC) FILETIME=[47E01010:01C9604B]
X-AV-Checked: No Virus Found
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Alan Cox a écrit :
>>> And easy fix could be to always report TIOCM_CTS.
>>>
>> Ping ?
>>
>> The bug is still present on git tree and I have got no replies.
> 
> Send patches instead then ;)
> 
> If the chip can sense the CTS line then you could check on a timer event
May be it could be usefull to do something generic that call driver
get_mctrl instead of doing it in the driver (like it is done in
bfin_5xx, sa1100, ...)

> but it might be cleaner to add the functionality needed to allow a driver
> to say "always call my start_tx" method.
Or to say "recheck get_mctrl before my start_tx).
But have you got an idea how the driver could ask that to the serial core ?
flags in struct uart_port seems full.


Matthieu
