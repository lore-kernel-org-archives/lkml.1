Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbXHSTyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbXHSTyN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 15:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbXHSTx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 15:53:58 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49905 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbXHSTx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 15:53:58 -0400
Message-ID: <46C89FCA.3010802@garzik.org>
Date: Sun, 19 Aug 2007 15:53:46 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       kvm-devel@lists.sourceforge.net,
       Laurent Vivier <Laurent.Vivier@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       cotte@de.ibm.com
Subject: Re: List stripping out cc's
References: <46BC8B39.6050202@bull.net> <200708131615.42643.borntraeger@de.ibm.com> <46C06885.3020908@qumranet.com> <200708131626.36275.borntraeger@de.ibm.com> <46C06CA2.8010303@qumranet.com> <20070813204023.GA10283@osiris.ibm.com> <46C80E40.9@qumranet.com>
In-Reply-To: <46C80E40.9@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Heiko Carstens wrote:
>>>  The only thing remotely relevant in the list config is that 'Filter 
>>> out  duplicate messages to list members (if possible)' is set as a 
>>> default for  new members.  Maybe this means that if a cc is also part 
>>> of the list, that  cc is stripped (which seems a wierd 
>>> implementation; I'd have expected that  cc be kept and just one copy 
>>> sent out).
>>>
>>>  Anybody have a clue?
>>>     
>>
>> I got also removed when I was cc'ed. IIRC that started when I 
>> subscribed to
>> the list. So it looks like people who are subscribed to the list get
>> removed from the cc list.
>> That's very annoying btw. ;)
>>   
> 
> I think I see what is happening.  The list gets a message that you are 
> copied on.  It sees you have opted not to receive duplicates, it strips 
> you from the cc list, since it knows that you will receive another copy 
> by direct routing (outside the list).

Well, there is also /quite/ the problem with the Mail-Followup-To 
header, which causes most mailers to ignore the preferences of the 
community in favor of the preferences of the message author -- which 
totally screws up traditional To/CC handling on LKML.

	Jeff



