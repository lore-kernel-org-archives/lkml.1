Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbZDFW0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbZDFW0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 18:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbZDFW0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 18:26:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:25770 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbZDFW0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 18:26:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-type:content-transfer-encoding:x-mailer
         :thread-index:content-language;
        b=Dsy0gqXR5UI7Yrrq0ZMBSJ5GuxtB/cMj6rDsMak0WdOSmrdR9WB7GdGpGFR15DTnY6
         tIyorz/qGmI80Op43tR8zasMZandmL6EJXt0PCwHPikl0oZE493bZzXFnQhDBxjKtTAZ
         IZ8H7jxklY6ujhf/4D0D+8VkvREHW+pZrcdnc=
From: "Hua Zhong" <hzhong@gmail.com>
To: "'Ray Lee'" <ray-lk@madrabbit.org>
Cc: "'Theodore Tso'" <tytso@mit.edu>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Jens Axboe'" <jens.axboe@oracle.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com> 	<alpine.LFD.2.00.0904060803141.4023@localhost.localdomain> 	<20090406151054.GD5178@kernel.dk> <alpine.LFD.2.00.0904060840080.3863@localhost.localdomain> 	<20090406183157.GD7376@mit.edu> <alpine.LFD.2.00.0904061255160.4134@localhost.localdomain> 	<002501c9b6f3$f85b4910$e911db30$@com> <20090406211931.GB8586@mit.edu> 	<003001c9b6ff$a9259ce0$fb70d6a0$@com> <2c0942db0904061504l6504934bi446f7425fcd38470@mail.gmail.com>
In-Reply-To: <2c0942db0904061504l6504934bi446f7425fcd38470@mail.gmail.com>
Subject: RE: [PATCH 0/8][RFC] IO latency/throughput fixes
Date: Mon, 6 Apr 2009 15:25:36 -0700
Message-ID: <003401c9b706$9c4c1b50$d4e451f0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acm3A6K/smYfFB80QlyzKagJYAKDigAAh1PA
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Speaking as another embedded Linux guy, I don't update kernels on my
> embedded platforms willy-nilly, nor do I design a library that relies
> upon some default behavior without specifying it explicitly. That's
> just one of the prices of doing embedded development.
> 
> Your argument seems to be that someone may be relying upon default
> kernel behavior and, at the same time, is willing to continually
> upgrade their kernel. I'd argue that person is, y'know, nuts. If
> they're willing to upgrade their kernel on something that has that
> stringent of requirements, then they should be willing to force a
> mount option at the same time.

You are implying that if someone upgrades their kernel, then he must 
1) upgrade it continuously and 2) without any scrutiny. Both are untrue.

There are certain things people expect from the kernel, such as 
no ABI changes. To me ext3 default option falls into this category.

And even if they are nuts, you can't prove they don't exist, especially
given how many software already depends on the ordered mode.

You also conveniently forgot to quote my question about security. Both
are valid questions, not something I just totally made up.

> If they're willing to upgrade their kernel blindly, then they
> shouldn't be doing embedded development.

Linus once said that if you don't understand "not breaking user space" then
you should not be doing kernel development. Or something to that extent.


