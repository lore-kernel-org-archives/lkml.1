Return-Path: <linux-kernel-owner+w=401wt.eu-S1757598AbXHSULX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598AbXHSULX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 16:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756124AbXHSUKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 16:10:54 -0400
Received: from il.qumranet.com ([82.166.9.18]:42593 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757197AbXHSUKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 16:10:38 -0400
Message-ID: <46C8A3BB.5020505@qumranet.com>
Date: Sun, 19 Aug 2007 23:10:35 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       kvm-devel@lists.sourceforge.net,
       Laurent Vivier <Laurent.Vivier@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       cotte@de.ibm.com
Subject: Re: List stripping out cc's
References: <46BC8B39.6050202@bull.net> <200708131615.42643.borntraeger@de.ibm.com> <46C06885.3020908@qumranet.com> <200708131626.36275.borntraeger@de.ibm.com> <46C06CA2.8010303@qumranet.com> <20070813204023.GA10283@osiris.ibm.com> <46C80E40.9@qumranet.com> <46C89FCA.3010802@garzik.org>
In-Reply-To: <46C89FCA.3010802@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Sun, 19 Aug 2007 23:10:35 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Avi Kivity wrote:
>> Heiko Carstens wrote:
>>>>  The only thing remotely relevant in the list config is that
>>>> 'Filter out  duplicate messages to list members (if possible)' is
>>>> set as a default for  new members.  Maybe this means that if a cc
>>>> is also part of the list, that  cc is stripped (which seems a wierd
>>>> implementation; I'd have expected that  cc be kept and just one
>>>> copy sent out).
>>>>
>>>>  Anybody have a clue?
>>>>     
>>>
>>> I got also removed when I was cc'ed. IIRC that started when I
>>> subscribed to
>>> the list. So it looks like people who are subscribed to the list get
>>> removed from the cc list.
>>> That's very annoying btw. ;)
>>>   
>>
>> I think I see what is happening.  The list gets a message that you
>> are copied on.  It sees you have opted not to receive duplicates, it
>> strips you from the cc list, since it knows that you will receive
>> another copy by direct routing (outside the list).
>
> Well, there is also /quite/ the problem with the Mail-Followup-To
> header, which causes most mailers to ignore the preferences of the
> community in favor of the preferences of the message author -- which
> totally screws up traditional To/CC handling on LKML.
>

Sorry, this was about kvm-devel, not lkml -- I should have taken
linux-kernel off the cc list here to avoid increasing confusion. 
Somehow that felt wrong in an email about the evils of stripping out the
cc list.

I don't think there's an issue with M-F-T: here.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

