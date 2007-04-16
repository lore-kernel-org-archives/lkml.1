Return-Path: <linux-kernel-owner+w=401wt.eu-S1753008AbXDPEIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbXDPEIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 00:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754441AbXDPEIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 00:08:09 -0400
Received: from stinky.trash.net ([213.144.137.162]:63190 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbXDPEII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 00:08:08 -0400
Message-ID: <4622F630.9000905@trash.net>
Date: Mon, 16 Apr 2007 06:06:08 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Bartek <poemann@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at net/core/skbuff.c in linux-2.6.21-rc6
References: <9a8748490704100425t34ebafcdq866a923df80b9aca@mail.gmail.com>	 <19061b0b0704112218j13688c16xc755d66147f8fe6a@mail.gmail.com>	 <461DC70B.4000500@trash.net>	 <20070413.161635.26523891.davem@davemloft.net> <19061b0b0704150345h2bf6ad7el16d20a36c96f0ae9@mail.gmail.com>
In-Reply-To: <19061b0b0704150345h2bf6ad7el16d20a36c96f0ae9@mail.gmail.com>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bartek wrote:
> 2007/4/14, David Miller <davem@davemloft.net>:
> 
>> From: Patrick McHardy <kaber@trash.net>
>> Date: Thu, 12 Apr 2007 07:43:39 +0200
>>
>> > It seems we fail to reserve enough headroom for the case
>> > buf[0] == PPP_ALLSTATIONS and buf[1] != PPP_UI.
>> >
>> > Can you try this patch please?
>>
>> Any confirmation of this fix yet?
> 
> 
> I'm testing that patch, till now everything seems ok.


Please test Paul's patch instead and keep everyone CCed.
