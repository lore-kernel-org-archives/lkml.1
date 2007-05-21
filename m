Return-Path: <linux-kernel-owner+w=401wt.eu-S1761606AbXEUVMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761606AbXEUVMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 17:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756824AbXEUVM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 17:12:26 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45371 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756822AbXEUVM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 17:12:26 -0400
Message-ID: <46520B36.90409@garzik.org>
Date: Mon, 21 May 2007 17:12:22 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Robert de Rooy <robert.de.rooy@gmail.com>, linux-kernel@vger.kernel.org,
       Alan <alan@lxorguk.ukuu.org.uk>, bzolnier@gmail.com,
       linux-pcmcia@lists.infradead.org
Subject: Re: libata and legacy ide pcmcia failure
References: <464A0321.3080201@gmail.com> <464C1575.8070005@gmail.com> <464CB7C9.2080807@gmail.com> <46503192.1040300@gmail.com> <4650B9E3.7070409@gmail.com> <46518798.2020808@gmail.com> <4651B66E.6030505@gmail.com> <4651B834.3060702@gmail.com> <4651C4A1.6000101@gmail.com> <4651C74B.7020108@gmail.com>
In-Reply-To: <4651C74B.7020108@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Robert de Rooy wrote:
>> Hmm, good question. I do not have any other PCMCIA device to test.
>> The only other device I have is a Cardbus Wi-Fi adapter without Linux
>> support (Marvell). If I insert that adapter lspci seems to list it
>> properly, but without resorting to ndiswrapper I have no way of testing
>> it. In any case, seeing how Cardbus is PCI based this is probably
>> pointless to resolving this issue.
>>
>> Would any other log data from the controller initialization or lspci help?
> 
> Hmmm... I don't really know much about PCMCIA.  cc'ing linux-pcmcia.
> 
> The original thread can be read from the following URL.
> 
>   http://thread.gmane.org/gmane.linux.kernel/530099
> 
> It seems we're losing interrupts from the CFA device.  Any ideas?

Alan probably knows more, but ISTR some CFA PCMCIA devices that needed 
polling...

This isn't an ARM platform perchance, is it?

	Jeff


