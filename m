Return-Path: <linux-kernel-owner+w=401wt.eu-S1752758Ab0ABPP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab0ABPP5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 10:15:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725Ab0ABPP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 10:15:56 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:62006 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679Ab0ABPPz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 10:15:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GS0csirpyMCjoOkxWZAlyseoU2+IoHoyZQ/QuXfOZGLkDiHfqv0DittHly6LQOtjUI
         Skin8F7vI6Jit9Tvhf0xn9froJ5nyOxby+OkKOODQd6q19IAkdV1wHkwGbSE/0mm27y8
         ZhvSv5I1D4FR+8OphD08J2jLhKB5YcMjWUJO0=
MIME-Version: 1.0
In-Reply-To: <6f52f5b81001020713j5435cfadr1143806a9026adc2@mail.gmail.com>
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl>
	 <4B3F5264.7000008@gmail.com> <58607309.1e2f721f.4b3f57c0.807d3@o2.pl>
	 <6f52f5b81001020713j5435cfadr1143806a9026adc2@mail.gmail.com>
Date: Sat, 2 Jan 2010 16:15:53 +0100
Message-ID: <6f52f5b81001020715i79d2ea1j33443fa50fbb593c@mail.gmail.com>
Subject: Re: [suspend/resume] Re: userspace notification from module
From: Daniel Borkmann <danborkmann@googlemail.com>
To: =?UTF-8?B?QmFydMWCb21pZWogWmltb8WE?= <uzi18@o2.pl>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bartłomiej,

2010/1/2 Bartłomiej Zimoń <uzi18@o2.pl>
>
> This looks like more simple and could be good, after all i think about sending this
> module here to add to kernel. So if this solution could be ok i will start to code this part.
>
> Question is now what signal to choose to not terminate process and to be compatible
> with rest of Linux kernel?

Have a look at linux/signal.h. There's a section for non-POSIX
signals. May be you
could add a SIGSUS or sth similar into that list with a free signal
number to stay
compatible with the rest of the numbers.

Cool thing is that you now will have a kind of "observer" principle:
Don't call us, we call you ;)

Cheers,
Daniel Borkmann
