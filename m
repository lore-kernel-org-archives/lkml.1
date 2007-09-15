Return-Path: <linux-kernel-owner+w=401wt.eu-S1759575AbXIOIxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759575AbXIOIxS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 04:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbXIOIxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 04:53:11 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:39251 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbXIOIxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 04:53:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=tCsIp9ncshQaZqhjRDgtEz1CmlkNQr6QjCU7xY7zvaAtiuM8CsZl8r+P7YCfw7gbcImrdMNRP+ejDa8TvBsMfYsDdkTExnQBfWbA3yWXiLiIvoLYreRBrGNreqN9YcTFniiOAwifkTRghJQ3yscySVOs5TEvLg8Fiok86RYA8Oc=
Message-ID: <46EB9D6B.4040009@gmail.com>
Date: Sat, 15 Sep 2007 12:52:59 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
CC: Johannes Stezenbach <js@linuxtv.org>, Steven Toth <stoth@hauppauge.com>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
References: <20070913131353.GB26972@linuxtv.org> <46E95C54.4060502@gmail.com>	 <d9def9db0709130908r6e383c51wd115dd56cfe2beef@mail.gmail.com>	 <46E99F36.8090809@hauppauge.com>	 <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com>	 <46E9DDC7.4000403@hauppauge.com>	 <d9def9db0709132338v64ecdcf2ib4e69f1a9c986a5c@mail.gmail.com>	 <20070914113838.GA29962@linuxtv.org>	 <d9def9db0709140936u64041927p9e472f70d5a036c5@mail.gmail.com>	 <20070914204343.GA9058@linuxtv.org> <d9def9db0709141849r4dc489c2h88ac99e3d4f56d50@mail.gmail.com>
In-Reply-To: <d9def9db0709141849r4dc489c2h88ac99e3d4f56d50@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Markus,

Markus Rechberger wrote:

> The main discussion in this thread was about drivers in userspace
> are bad because the API will allow binary drivers. The guy
> who works for Hauppauge (again I also have good contacts
> at Hauppauge Europe) writes it's bad - for no technical reason.


AFAICS, Steven raised the same thoughts what i had.


> If someone points out that it is bad (after reading the whole thread)
> why don't we put X.org, bash, well everything into the kernel?


I am not saying that userspace is bad. In fact i am all for userspace,
_if_ there is much of a complication. For example we have had largely
complex devices. You might like to read this thread a while back.

This was the reason why we started up libdvbapi/mti (For those who don't
know what it is, libdvbapi/mti is a userspace approach for having device
support in userspace with complicated tuning algorithms with a lot of
calculations)

http://search.gmane.org/?query=Re%3A+%5BRFC%5D+Userspace+extensions%2C+was+Re%3A+%5Blinux-dvb%5D+%5Bpatch%5D+Add+support+for+different+tuning+algorithms&author=&group=linux.drivers.dvb&sort=relevance&DEFAULTOP=and&query=

For that demodulator and a successor for the same, i had finally moved
the same to in kernel with a lot of trouble. Maybe it is not as precise
as it should have been.

But what i mean is that we should use such approaches if there needs to
be a heavy valid reason and if there are many more devices going that
way, we should definitely move to userspace. Maybe the userspace idea is
a bit still immature.

That said, i don't see any such complexities with the XC3028


Manu
