Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbYBOFIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbYBOFIt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 00:08:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbYBOFIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 00:08:39 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:35888 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbYBOFIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 00:08:38 -0500
Message-ID: <47B51E55.6020203@davidnewall.com>
Date: Fri, 15 Feb 2008 15:38:37 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Gene Heskett <gene.heskett@gmail.com>, Greg KH <greg@kroah.com>,
       linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Handshaking on USB serial devices
References: <47B30291.2040905@davidnewall.com>	<200802141116.14722.gene.heskett@gmail.com>	<20080214163143.0915b44c@core>	<200802141255.22048.gene.heskett@gmail.com> <20080214193731.3c36acb0@core>
In-Reply-To: <20080214193731.3c36acb0@core>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> byte of a packet is being thrown away about .1% of the time for the pl2303, 
>> but I'm not sure if the FTDI driver still suffers from a similar rash.  I 
>>     
>
> A 20 byte low speed message is too small for flow control to account for
> it.

I agree.  I've observed the first byte of received data disappears on
pl2303 devices, but haven't spent time finding out why.  (It's on my list.)
