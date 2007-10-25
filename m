Return-Path: <linux-kernel-owner+w=401wt.eu-S1762961AbXJYUyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762961AbXJYUyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756392AbXJYUyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:54:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50426 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134AbXJYUyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:54:45 -0400
Message-ID: <47210263.5000405@zytor.com>
Date: Thu, 25 Oct 2007 13:53:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Adrian Bunk <bunk@kernel.org>, Jie Zhang <jzhang.linux@gmail.com>,
       bryan.wu@analog.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] blackfin: "extern inline" -> "static inline"
References: <20071024162643.GP30533@stusta.de>	 <8bd0f97a0710242000h7b6c97e7ia3f461c69b7d5de5@mail.gmail.com>	 <47200826.1060801@zytor.com> <20071025150545.GK30533@stusta.de>	 <8bd0f97a0710250916v5d3f0166qbfacf4abb0fc3d45@mail.gmail.com>	 <20071025165344.GL30533@stusta.de>	 <8bd0f97a0710251307m9f45f4dmf6d8cfa93af9fdf5@mail.gmail.com>	 <20071025201842.GT30533@stusta.de>	 <8bd0f97a0710251320m3490c53dpe85656a939e8536e@mail.gmail.com>	 <4720FC54.1020705@zytor.com> <8bd0f97a0710251345t6e50bcd3u11be001ee900d9cf@mail.gmail.com>
In-Reply-To: <8bd0f97a0710251345t6e50bcd3u11be001ee900d9cf@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> On 10/25/07, H. Peter Anvin <hpa@zytor.com> wrote:
>> Mike Frysinger wrote:
>>>> Do you have any example for your claim "to get gcc to not inline things
>>>> when building debug versions"?
>>> $ cat test.c
>>> __attribute__((always_inline)) int foo(void) { return 0; }
>>> int main(void){ return foo(); }
>>> $ gcc -g test.c -o test
>>> $ readelf -s test | grep FUNC | grep -v _
>>>     61: 00000000004004b8    11 FUNC    GLOBAL DEFAULT   13 foo
>>>     68: 00000000004004c3    11 FUNC    GLOBAL DEFAULT   13 main
>>>
>>> looks pretty straightforward to me
>> For "debug version" meaning -O0, this is true.
> 
> which is what i meant, sorry for not being more clear
> 
> anyways, this is all moot ... we dont want "always inline" nor do we
> want "static inline" for our string functions.  we want the classical
> GNU meaning of "extern inline" which means we're going to either have
> a Blackfin specific "extern_inline" define or we get one added to the
> common compiler headers and use that.
> 
> Peter (or is it "H. Peter" ?): you going to post a patch or should i ?
> -mike

Just "Peter" is fine :)

Go right ahead.

	-hpa
