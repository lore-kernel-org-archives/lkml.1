Return-Path: <linux-kernel-owner+w=401wt.eu-S1757707AbZKJS4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707AbZKJS4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 13:56:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757695AbZKJS4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 13:56:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46694 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757461AbZKJS4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 13:56:36 -0500
Message-ID: <4AF9B5AB.5010800@zytor.com>
Date: Tue, 10 Nov 2009 10:49:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Avi Kivity <avi@redhat.com>, Willy Tarreau <w@1wt.eu>,
       Pavel Machek <pavel@ucw.cz>, Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
References: <4AF4526B.4060101@zytor.com>	<40101cc30911061418w357b74d8i3bf9a9537de052d4@mail.gmail.com>	<20091108173708.GF1372@ucw.cz>	<40101cc30911080940s18eb26bbg641beeaddbc25c3d@mail.gmail.com>	<20091108181016.GB32364@elf.ucw.cz>	<alpine.DEB.2.00.0911082026430.30789@aurora.sdinet.de>	<20091108193618.GB4186@elf.ucw.cz>	<40101cc30911081147j77f7b81o86f2cc5a869aca1f@mail.gmail.com>	<20091108195158.GD4186@elf.ucw.cz>	<20091108200852.7f2cf092@lxorguk.ukuu.org.uk>	<20091110052711.GA15338@1wt.eu>	<4AF9020C.90108@zytor.com>	<4AF9435F.2070103@redhat.com>	<20091110105642.215804e0@lxorguk.ukuu.org.uk>	<4AF99E04.8080704@zytor.com> <20091110172454.3c4481f2@lxorguk.ukuu.org.uk>
In-Reply-To: <20091110172454.3c4481f2@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2009 09:24 AM, Alan Cox wrote:
>>
>> In the short term, yes, of course.  However, if we're going to do
>> emulation, we might as well do it right.
> 
> Why is using KVM doing it right ? It sounds like its doing it slowly,
> and hideously memory inefficiently. You are solving an uninteresting
> general case problem when you just need two tiny fixups (or perhaps 3 if
> you want to fix up early x86-64 prefetch)

Why do we only need "two tiny fixups"?  Where do we draw the line in
terms of ISA compatibility?  One could easily argue that the Right
Thing[TM] is to be able to process any optional instruction -- otherwise
one has a very difficult place to draw a line.

Consider SSE3, for example.  Why should the same concept not apply to
SSE3 instructions as to CMOV?
	
	-hpa
