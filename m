Return-Path: <linux-kernel-owner+w=401wt.eu-S1762071AbZENAuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762071AbZENAuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 20:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbZENAuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 20:50:00 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45492 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448AbZENAt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 20:49:59 -0400
Message-ID: <4A0B6A96.2030008@garzik.org>
Date: Wed, 13 May 2009 20:49:26 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Hitoshi Mitake <h.mitake@gmail.com>, Roland Dreier <rdreier@cisco.com>,
       Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, tglx@linutronix.de,
       rpjday@crashcourse.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Remove readq()/writeq() on 32-bit
References: <49EE37AF.4020507@zytor.com>	 <20090421.173123.191021055.davem@davemloft.net>	 <adak55438gp.fsf_-_@cisco.com>	 <20090428.221228.217954247.davem@davemloft.net>	 <20090429115654.GC11586@elte.hu> <49F843BC.7020902@garzik.org>	 <adahc071ie4.fsf@cisco.com> <49F8B1A1.4010208@garzik.org> <a6b9f31a0905122232s2d23b4e3h6e447c3fa5c29ee6@mail.gmail.com> <4A0B2B54.5090803@zytor.com> <4A0B4C1C.9000706@garzik.org> <4A0B5A34.1080301@zytor.com>
In-Reply-To: <4A0B5A34.1080301@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeff Garzik wrote:
>> Judging from this thread and past, I think people will continue to 
>> complain and get confused, even with the above.
>>
> 
> Do you really think so?  Seems unfortunate, since an API rename would be
> way more invasive.  This is the entirety of the header patch
> (compile-tested using 32-bit allyesconfig).

The header patch does not lessen the confusion, because you cannot look 
at the code and immediately tell what is going on...

Having a single function's behavior change based on #include selection 
is /not/ intuitive at all, particularly for driver writers.  That is 
unlike almost every other Linux API, where functions' behavior stays 
constant across platforms, regardless of magic "under the hood."

That sort of trick is reserved for arch maintainers who know what they 
are doing :)

	Jeff



