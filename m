Return-Path: <linux-kernel-owner+w=401wt.eu-S966017AbXEVThy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966017AbXEVThy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 15:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757430AbXEVThq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 15:37:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:1823 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757299AbXEVThq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 15:37:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=kPuVdOtEWJEI9Yb/RNLKy+gZKAsQofW8wRzmWNl0NO2yA8BeJ+o1f2Pg5VTZuMUnNMJY+eWQLrPVc72KzaBRFf2EA3uW5tTkJaRWyl+0kJUbYrjEaEU/O9UERVk7Se8CZzUYX7nzJ1g3SyNZUBfCKLkNqhPrD2py1LEATxhqcMc=
Message-ID: <46534679.4030505@gmail.com>
Date: Tue, 22 May 2007 21:37:29 +0200
From: Robert de Rooy <robert.de.rooy@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org,
       Alan <alan@lxorguk.ukuu.org.uk>, bzolnier@gmail.com,
       linux-pcmcia@lists.infradead.org
Subject: Re: libata and legacy ide pcmcia failure
References: <464A0321.3080201@gmail.com> <464C1575.8070005@gmail.com> <464CB7C9.2080807@gmail.com> <46503192.1040300@gmail.com> <4650B9E3.7070409@gmail.com> <46518798.2020808@gmail.com> <4651B66E.6030505@gmail.com> <4651B834.3060702@gmail.com> <4651C4A1.6000101@gmail.com> <4651C74B.7020108@gmail.com> <46520B36.90409@garzik.org>
In-Reply-To: <46520B36.90409@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Tejun Heo wrote:
>> Robert de Rooy wrote:
>>> Hmm, good question. I do not have any other PCMCIA device to test.
>>> The only other device I have is a Cardbus Wi-Fi adapter without Linux
>>> support (Marvell). If I insert that adapter lspci seems to list it
>>> properly, but without resorting to ndiswrapper I have no way of testing
>>> it. In any case, seeing how Cardbus is PCI based this is probably
>>> pointless to resolving this issue.
>>>
>>> Would any other log data from the controller initialization or lspci 
>>> help?
>>
>> Hmmm... I don't really know much about PCMCIA.  cc'ing linux-pcmcia.
>>
>> The original thread can be read from the following URL.
>>
>>   http://thread.gmane.org/gmane.linux.kernel/530099
>>
>> It seems we're losing interrupts from the CFA device.  Any ideas?
>
> Alan probably knows more, but ISTR some CFA PCMCIA devices that needed 
> polling...
>
> This isn't an ARM platform perchance, is it?
>
>     Jeff
>
>
>
No, it is a ThinkPad T41 with Intel Pentium M.
I have posted full logs to the list, but the copy to linux-pcmcia got 
stuck in moderator approval due to exceeding a 40KB limit.
