Return-Path: <linux-kernel-owner+w=401wt.eu-S1754975AbZGNPXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbZGNPXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 11:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831AbZGNPXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 11:23:49 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:51647 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbZGNPXt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 11:23:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bvinQiJbDaUuH3S1BHxh5yNiA0AlzmijCAXeJdtkwD/SYbLAFbGzKvEdBw3EvkOhtY
         bn8R0uO/8s4+PjIXjCak9xqRNVf7asg4mKar/bQPzaScdIAb0BDYGbniJAQq5lllZo5h
         DIkui33MUPQcrcf4GRxIFnK7hA0XqbdJeFq1I=
MIME-Version: 1.0
In-Reply-To: <48F90369174947C98F6AE82888FA60C5@realtek.com.tw>
References: <48F90369174947C98F6AE82888FA60C5@realtek.com.tw>
Date: Tue, 14 Jul 2009 17:23:47 +0200
Message-ID: <63386a3d0907140823s62140f85t7947a8ebe02382e9@mail.gmail.com>
Subject: Re: jiffies got lost because of printk
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: =?Big5?B?qkyr2KZ3?= <colin@realtek.com.tw>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/14 ªL«Ø¦w <colin@realtek.com.tw>:

> We found that system time is not synced with RTC time on our embedded
> system. (...)
> interrupt will be disabled for more than 1 HZ and timer interrupt will be
> lost.

This sounds like you're using some kind of old timekeeping code.
Make sure you migrate to using a proper time source and clock
events. It will compensate for lost jiffies in situations like this.

Linus Walleij
