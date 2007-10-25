Return-Path: <linux-kernel-owner+w=401wt.eu-S1760692AbXJYU2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760692AbXJYU2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600AbXJYU2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:28:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48011 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbXJYU2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:28:44 -0400
Message-ID: <4720FC54.1020705@zytor.com>
Date: Thu, 25 Oct 2007 13:28:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Adrian Bunk <bunk@kernel.org>, Jie Zhang <jzhang.linux@gmail.com>,
       bryan.wu@analog.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] blackfin: "extern inline" -> "static inline"
References: <20071024162643.GP30533@stusta.de>	 <40401db90710241947i15e40e78v292e52f5229d9d35@mail.gmail.com>	 <8bd0f97a0710242000h7b6c97e7ia3f461c69b7d5de5@mail.gmail.com>	 <47200826.1060801@zytor.com> <20071025150545.GK30533@stusta.de>	 <8bd0f97a0710250916v5d3f0166qbfacf4abb0fc3d45@mail.gmail.com>	 <20071025165344.GL30533@stusta.de>	 <8bd0f97a0710251307m9f45f4dmf6d8cfa93af9fdf5@mail.gmail.com>	 <20071025201842.GT30533@stusta.de> <8bd0f97a0710251320m3490c53dpe85656a939e8536e@mail.gmail.com>
In-Reply-To: <8bd0f97a0710251320m3490c53dpe85656a939e8536e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
>> Do you have any example for your claim "to get gcc to not inline things
>> when building debug versions"?
> 
> $ cat test.c
> __attribute__((always_inline)) int foo(void) { return 0; }
> int main(void){ return foo(); }
> $ gcc -g test.c -o test
> $ readelf -s test | grep FUNC | grep -v _
>     61: 00000000004004b8    11 FUNC    GLOBAL DEFAULT   13 foo
>     68: 00000000004004c3    11 FUNC    GLOBAL DEFAULT   13 main
> 
> looks pretty straightforward to me
> -mike

For "debug version" meaning -O0, this is true.

	-hpa
