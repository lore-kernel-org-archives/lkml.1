Return-Path: <linux-kernel-owner+w=401wt.eu-S1753114AbZIIMvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114AbZIIMvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 08:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbZIIMvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 08:51:09 -0400
Received: from fmailhost01.isp.att.net ([207.115.11.51]:64870 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbZIIMvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 08:51:08 -0400
X-Originating-IP: [76.250.133.175]
Message-ID: <4AA7A3F5.2000503@ameritech.net>
Date: Wed, 09 Sep 2009 08:47:49 -0400
From: "F. Heitkamp" <heitkamp@ameritech.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.15pre) Gecko/2009090807 Lightning/0.6a1 SeaMonkey/2.0a1pre
MIME-Version: 1.0
To: Ulrich Drepper <drepper@gmail.com>
CC: Andreas Schwab <schwab@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: popen2 popen call
References: <alpine.DEB.1.10.0908270803540.3447@pc1lin.fred.org> 	<m3prahctv6.fsf@hase.home> <082720091839.15057.4A96D2D10002C02000003AD122230647029B0A02D2080C0A9B079D0A030EBF9F030E059B070A08@att.net> 	<a36005b50908271215v27f06476p5808b9fb6b19fa81@mail.gmail.com> 	<4AA2A257.3000409@ameritech.net> <a36005b50909060155k61129b79iab0a0e6db7008ed2@mail.gmail.com>
In-Reply-To: <a36005b50909060155k61129b79iab0a0e6db7008ed2@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> On Sat, Sep 5, 2009 at 10:39, F. Heitkamp<heitkamp@ameritech.net>  wrote:
>    
>> linux-pipe.c:(.text+0x3b): warning: warning: pipe2 is not implemented and
>> will always fail
>>      
>
> you will get this warning if the glibc you're using was compiled
> without appropriate kernel headers.  I.e., the definition of
> __NR_pipe2 wasn't available.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>    
Compiling glibc with newer headers worked!  Thank you all.

Fred

