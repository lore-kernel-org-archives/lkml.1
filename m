Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbZAKUPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbZAKUPv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 15:15:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbZAKUPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 15:15:42 -0500
Received: from mail-bw0-f29.google.com ([209.85.218.29]:49459 "EHLO
	mail-bw0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbZAKUPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 15:15:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GUWJlu0jTc3cQA1SQT21uyLSR5Vq4POkCoipBQbWixBdk5MTRBs/Hs/Sa+aRln7+7b
         +j3PRxq/xjOB+WIP92o1jy9EaihiPoZt+gjow1Xit1o9q9s9BaOjA6L+IZFoaV6rKcL/
         G7gCy7aDXiDxtCvutXjRhYVGE/L20rkJ7ZgGQ=
Message-ID: <8db1092f0901111215m5712caccvc0d2e5e7cb7e8f7@mail.gmail.com>
Date: Sun, 11 Jan 2009 21:15:38 +0100
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
Subject: Re: 2.6.29-rc1 does not resume on Lenove T61
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
In-Reply-To: <c4e36d110901111152o63c4cda0j88f4c89950bd2b90@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110901111152o63c4cda0j88f4c89950bd2b90@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/11 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> Hi
>
> I've booted and tested 2.6.29-rc1 (c59765042f53a79a7a65585042ff463b69cb248c)
>
> I've observed that suspend is unusable - it goes to sleep - the sleep
> LED is on. After few secs system turns on back itself - and stays in
> some frozen state

A have similar situation, one difference: I get blank screen during
resume from suspend to ram. Also sometimes, like You, system turns on
back itself.

[...]

> but most probably this is not very helpful - however it's kind of hard
> to bisect kernel, because patches in the transition from
> 2.6.28->2.6.29-rc1 usually caused a lot of unstable behavior on my
> T61.

The same. Suspend to disk die on this message:
http://www.unixy.pl/maciek/download/kernel/2.6.29-rc1/pc/img_0002.jpg
(this is during go to suspend to disk, NOT resume)

I try bisect, but I got many other problems, like this:
http://www.unixy.pl/maciek/download/kernel/2.6.29-rc1/pc/img_0003.jpg

So, I cannot finish bisect.

>

Config, dmesg:
http://www.unixy.pl/maciek/download/kernel/2.6.29-rc1/pc/


-- 
Maciej Rutecki
http://www.maciek.unixy.pl
