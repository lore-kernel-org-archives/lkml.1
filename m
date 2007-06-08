Return-Path: <linux-kernel-owner+w=401wt.eu-S1032298AbXFHWLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032298AbXFHWLU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 18:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968811AbXFHWLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 18:11:07 -0400
Received: from rtr.ca ([64.26.128.89]:4259 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968664AbXFHWLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 18:11:03 -0400
Message-ID: <4669D3F5.7040300@rtr.ca>
Date: Fri, 08 Jun 2007 18:11:01 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Robert de Rooy <robert.de.rooy@gmail.com>
Cc: Mark Lord <mlord@pobox.com>, Tejun Heo <htejun@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, bzolnier@gmail.com,
       linux-pcmcia@lists.infradead.org,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: libata and legacy ide pcmcia failure
References: <464A0321.3080201@gmail.com>	<464C1575.8070005@gmail.com> <464CB7C9.2080807@gmail.com>	<46503192.1040300@gmail.com> <4650B9E3.7070409@gmail.com>	<46518798.2020808@gmail.com> <4651B66E.6030505@gmail.com>	<4651B834.3060702@gmail.com> <4651C4A1.6000101@gmail.com>	<4651C74B.7020108@gmail.com> <46520B36.90409@garzik.org> <20070523150229.00a0c3c4@the-village.bc.nu> <466718B6.4080105@gmail.com> <4667B39D.209@gmail.com> <46685AE5.4010908@gmail.com> <466900F3.7040801@gmail.com> <46694FB2.6040007@pobox.com> <4669D2D8.3020806@gmail.com>
In-Reply-To: <4669D2D8.3020806@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert de Rooy wrote:
> Mark Lord wrote:
>> I still don't see much evidence that interrupts are actually 
>> functioning here.
>> It would be good to see /proc/interrupts before/after libata tries to 
>> talk to it.
>>
>> Let's assume for the moment that interrupts are b0rken.
>> The legacy IDE driver can talk to such devices completely without 
>> interrupts,
>> if the IDE polling patch (below) is applied.
>>
>> So, Robert:  could you try again with the old IDE driver,
>> except apply this patch to it first?  This will give valuable info.
>
> I tried the patch, but a get a kernel panic on boot with it. I can try 
> to get a screenshot of it tomorrow.

Oh crap.  I did test it a couple of months ago, but my boot/root drive
is libata not IDE -- so no panic on boot with it.  After booting, it worked
just fine talking to PC-CARD CF devices using the polling.

=ml
