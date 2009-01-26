Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbZAZTzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbZAZTzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 14:55:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbZAZTyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 14:54:54 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:40228 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576AbZAZTyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 14:54:51 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 26 Jan 2009 11:54:35 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Pavel Pisa <pisa@cmp.felk.cvut.cz>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Unexpected cascaded epoll behavior - my mistake or kernel bug
In-Reply-To: <200901260228.54098.pisa@cmp.felk.cvut.cz>
Message-ID: <alpine.DEB.1.10.0901261152160.26576@alien.or.mcafeemobile.com>
References: <200901230109.55706.pisa@cmp.felk.cvut.cz> <alpine.DEB.1.10.0901241355120.9071@alien.or.mcafeemobile.com> <200901260228.54098.pisa@cmp.felk.cvut.cz>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2009, Pavel Pisa wrote:

> Hello Davide,
> 
> thanks for fast reply and effort.
> 
> I have tested your patch with patched and unpatched 2.6.28.2 kernel.
> The outputs are attached. The patched kernel passes all your tests.
> 
> But I have bad news. My library code does not fall into busy loop
> after your patching but my FIFO tests do not work even in
> single level epoll scenario. The strace output is attached as well.
> I try to do more testing tomorrow. I have returned from weekend trip
> at the evening today and I have not much time for deeper analysis.
> 
> But it looks like write level sensitive events are not triggering
> for epoll at all. The pipe is not fill by any character and specified
> timeout is triggered with next message as fail results.
>   @ pipe #X evptrig wr timeout
>   @ pipe #X evptrig rd timeout
>  
> If you want to test the code on your box, download library
> 
> http://cmp.felk.cvut.cz/~pisa/ulan/ul_evpoll-090123.tar.gz
> 
> The simple "make" in the top directory should work.

It'd be really great if you could spare me having to dig into few 
thousands lines of userspace library code, and you could isolate a little 
bit better what is the expected result, and the error result.



- Davide


