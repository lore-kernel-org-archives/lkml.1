Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbYBFPQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbYBFPQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 10:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbYBFPQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 10:16:05 -0500
Received: from smtp2.sssup.it ([193.205.80.100]:56696 "EHLO smpt.sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751465AbYBFPQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 10:16:04 -0500
Message-ID: <47A9B8F5.3040500@gandalf.sssup.it>
Date: Wed, 06 Feb 2008 14:41:09 +0100
From: michael <trimarchi@gandalf.sssup.it>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
CC: Remy Bohmer <linux@bohmer.net>, fabio@gandalf.sssup.it,
       Andrew Victor <linux@maxim.org.za>, Chip Coldwell <coldwell@redhat.com>,
       Marc Pignat <marc.pignat@hevs.ch>, David Brownell <david-b@pacbell.net>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH -mm v4 6/9] atmel_serial: Split the interrupt handler
References: <20080129224316.GA23155@gandalf.sssup.it>	<479FB2D7.4020804@gandalf.sssup.it>	<20080130104113.48ec376f@dhcp-252-066.norway.atmel.com>	<47A051A7.7030004@gandalf.sssup.it>	<20080130133659.55ebd828@dhcp-252-066.norway.atmel.com>	<47A09723.7020000@gandalf.sssup.it>	<20080130164631.7de4f6bd@dhcp-252-066.norway.atmel.com>	<47A12A2E.5040309@gandalf.sssup.it>	<20080131160721.6dddf30e@dhcp-252-066.norway.atmel.com>	<47A76106.3000103@gandalf.sssup.it>	<20080204212523.07a6da9e@siona>	<47A856AF.5010202@gandalf.sssup.it> <20080206133012.0a5df53e@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080206133012.0a5df53e@dhcp-252-066.norway.atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,
Haavard Skinnemoen wrote:
> On Tue, 05 Feb 2008 13:29:35 +0100
> michael <trimarchi@gandalf.sssup.it> wrote:
>
>   
>> Just one question:
>> Receiving with hardware handshake works without PDC?
>>     
>
> I don't know...I haven't tried. These patches shouldn't change anything
> though.
>
> Haavard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>   
I refer to this part of documentation:

"The USART behavior when hardware handshaking is enabled is the same as 
the behavior in
standard synchronous or asynchronous mode, except that the receiver 
drives the RTS pin as
described below and the level on the CTS pin modifies the behavior of 
the transmitter as
described below. Using this mode requires using the PDC channel for 
reception. The transmitter
can handle hardware handshaking in any case."

Regards Michael

