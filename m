Return-Path: <linux-kernel-owner+w=401wt.eu-S1758025AbZKJUI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025AbZKJUI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 15:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757979AbZKJUI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 15:08:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52090 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757975AbZKJUIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 15:08:55 -0500
Message-ID: <4AF9C6AB.8080006@zytor.com>
Date: Tue, 10 Nov 2009 12:01:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Willy Tarreau <w@1wt.eu>,
       Pavel Machek <pavel@ucw.cz>, Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
References: <4AF4526B.4060101@zytor.com>	<40101cc30911061418w357b74d8i3bf9a9537de052d4@mail.gmail.com>	<20091108173708.GF1372@ucw.cz>	<40101cc30911080940s18eb26bbg641beeaddbc25c3d@mail.gmail.com>	<20091108181016.GB32364@elf.ucw.cz>	<alpine.DEB.2.00.0911082026430.30789@aurora.sdinet.de>	<20091108193618.GB4186@elf.ucw.cz>	<40101cc30911081147j77f7b81o86f2cc5a869aca1f@mail.gmail.com>	<20091108195158.GD4186@elf.ucw.cz>	<20091108200852.7f2cf092@lxorguk.ukuu.org.uk>	<20091110052711.GA15338@1wt.eu>	<4AF9020C.90108@zytor.com>	<4AF9435F.2070103@redhat.com>	<20091110105642.215804e0@lxorguk.ukuu.org.uk>	<4AF99E04.8080704@zytor.com> <20091110172454.3c4481f2@lxorguk.ukuu.org.uk> <4AF9B5AB.5010800@zytor.com> <4AF9C3EF.6000705@redhat.com>
In-Reply-To: <4AF9C3EF.6000705@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2009 11:50 AM, Avi Kivity wrote:
>>
>> Consider SSE3, for example.  Why should the same concept not apply to
>> SSE3 instructions as to CMOV?
> 
> Because then user programs would run 20x or more slower than the user 
> expects.  Better to terminate early (and teach userspace how to choose 
> the instruction subset correctly).
> 

I picked the example carefully: SSE3 is a small set of instructions
which probably aren't used very heavily.  In that sense, it has
*exactly* the same properties as CMOV - if you have the source, you're
better off recompiling, but it *might* help you if you happen to only
have a binary.

What I want people to understand is that this is a *huge* rathole, and
it doesn't have any obvious bottom that I can see.

	-hpa
