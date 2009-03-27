Return-Path: <linux-kernel-owner+w=401wt.eu-S1752217AbZC0XZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbZC0XZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbZC0XZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:25:43 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:34330 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbZC0XZm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:25:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=V+Xl6YZzdxp0/hPXOpP5gnJzaf/8C5kMkc2hbwD9dLKH8ppkKKYFx2Enu5+rPDT6Yw
         7Hs8URvjQU/R//LY5n4sIQbXDdrm1FCPoe/RdxQC4VIvKTZsE5bhRvJLRcccO/rFS69y
         ++BmcHwf/GGsmDBzNaSuBZo/9rYfVCHHRQj68=
MIME-Version: 1.0
In-Reply-To: <49CD5E59.6030805@msgid.tls.msk.ru>
References: <84a01a8b0903250545n799a8727o1faad60c8eaf372e@mail.gmail.com>
	 <84a01a8b0903270244s146ca50cr2758d36c2d9d77cd@mail.gmail.com>
	 <49CD4967.2090606@msgid.tls.msk.ru>
	 <84a01a8b0903271517t668c6276l7fe098d74c24b836@mail.gmail.com>
	 <84a01a8b0903271530of8d43ffhf77e7ba73e309f75@mail.gmail.com>
	 <49CD564E.6050101@msgid.tls.msk.ru>
	 <84a01a8b0903271555i7a4fea50nd95009539aa2f94d@mail.gmail.com>
	 <49CD5AC6.3020806@msgid.tls.msk.ru>
	 <84a01a8b0903271610u17267f87u65b097ac2d755a52@mail.gmail.com>
	 <49CD5E59.6030805@msgid.tls.msk.ru>
Date: Sat, 28 Mar 2009 00:25:38 +0100
Message-ID: <84a01a8b0903271625y30a56113l87aa517385120e6@mail.gmail.com>
Subject: Re: epoll_ctl and const correctness
From: nicolas sitbon <nicolas.sitbon@gmail.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

read() and poll() are very old functions, a long time ago, int was
nearly the only used type. Today, people uses good programming
practices, mixing information (the size read) and error is a very poor
design and a bad practice, as with read().

2009/3/28 Michael Tokarev <mjt@tls.msk.ru>:
> nicolas sitbon wrote:
>>
>> is it stupid to ask how a size can be negative? who is stupid? you're
>> boring with my question, just tell me please how a size can be
>> negative?
>
> Yes I'm bored with your questions.  And am suggesting you to stop
> asking me now.  That's enough.
>
> As of size being negative - how one can read() negative number
> of bytes for example?  How one can poll() waiting for a maximum
> of negative number of milliseconds?
>
> This is my last reply to you.  I have something more useful to do.
>
> /mjt
>
