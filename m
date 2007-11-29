Return-Path: <linux-kernel-owner+w=401wt.eu-S1761283AbXK2Hkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761283AbXK2Hkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 02:40:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754210AbXK2HjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 02:39:04 -0500
Received: from sa15.bezeqint.net ([192.115.104.30]:38337 "EHLO
	sa15.bezeqint.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080AbXK2HjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 02:39:01 -0500
Message-ID: <474E6C86.8090209@panasas.com>
Date: Thu, 29 Nov 2007 09:38:46 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: Jan Engelhardt <jengelh@computergmbh.de>,
       =?ISO-8859-1?Q?=22J=2EA=2E_?= =?ISO-8859-1?Q?Magall=F3n=22?= 
	<jamagallon@ono.com>,
       "Linux-Kernel," <linux-kernel@vger.kernel.org>
Subject: Re: void* arithmnetic
References: <20071129010531.22b3a71f@werewolf>	 <Pine.LNX.4.64.0711290130170.22052@fbirervta.pbzchgretzou.qr> <d82e647a0711281719s74035e98pc228ce0da4f3b00d@mail.gmail.com>
In-Reply-To: <d82e647a0711281719s74035e98pc228ce0da4f3b00d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov. 29, 2007, 3:19 +0200, "Ming Lei" <tom.leiming@gmail.com> wrote:
> 2007/11/29, Jan Engelhardt <jengelh@computergmbh.de>:
>> On Nov 29 2007 01:05, J.A. Magallón wrote:
>>> Since begin of the ages the build of the nvidia driver says things like
>>> this:
>>>
>> Explicitly adding -Wpointer-arith to ones own Makefile is like
>> admitting the code might be problematic. :->
>>
>>
>> I think sizeof(void *) == 1 is taken as granted as sizeof(int) >= 4
>> these days. Sigh.
> sizeof(void *) == 4, sizeof(void)==1, :)
well, sizeof(void *) == sizeof(unsigned long) maybe :)

>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

