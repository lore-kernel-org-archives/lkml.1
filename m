Return-Path: <linux-kernel-owner+w=401wt.eu-S1753046AbZI2XSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbZI2XSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 19:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbZI2XSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 19:18:10 -0400
Received: from smtp-01.mandic.com.br ([200.225.81.132]:39965 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbZI2XSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 19:18:09 -0400
Message-ID: <4AC295B2.3000503@cesarb.net>
Date: Tue, 29 Sep 2009 20:18:10 -0300
From: Cesar Eduardo Barros <cesarb@cesarb.net>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Cesar Eduardo Barros <cesarb@cesarb.net>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rolandd@cisco.com, dwalker@fifo99.com
Subject: Re: [PATCH] WARN_ONCE(): use bool for condition
References: <4ABFAB27.1040608@cesarb.net>	<1254075912-17557-1-git-send-email-cesarb@cesarb.net> <20090929135947.7ccc3d8c.akpm@linux-foundation.org> <4AC2943E.2070502@cesarb.net>
In-Reply-To: <4AC2943E.2070502@cesarb.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cesar Eduardo Barros escreveu:
> Andrew Morton escreveu:
>> On Sun, 27 Sep 2009 15:25:12 -0300
>> Cesar Eduardo Barros <cesarb@cesarb.net> wrote:
>>
>>> Use the type bool for __ret_warn_once and __ret_warn_on, instead of int
>>> with a double negation. This matches the intent of the code better and
>>> should allow the compiler to generate better code, like in commit
>>> 70867453092297be9afb2249e712a1f960ec0a09. However, some versions of gcc
>>> seems to pessimize the code instead when the condition is not trivial.
>>
>> It would be nice if we had some accurate numbers on the kernel size
>> reductions from this, please.  I assume that the patch is still of
>> benefit in 2.6.32-rc1(2?), but it's always good to confirm.
> 
> In the first patch, Daniel Walker saw a decrease of 504 bytes in IA-32, 
> and I saw a decrease of 1462 bytes in x86-64 defconfig. I will resend it 
> 
> For this one, on the other hand, I am not sure whether it should be 
> included or dropped. While Daniel Walker saw a decrease of 84 bytes in 
> IA-32, I saw an *increase* of 598 bytes in x86-64 defconfig. It seems 

Forgot to mention, all my testing was against v2.6.31-9194-g0d9df25

-- 
Cesar Eduardo Barros
cesarb@cesarb.net
cesar.barros@gmail.com
