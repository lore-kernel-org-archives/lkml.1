Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbYKNWkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbYKNWkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 17:40:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbYKNWkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 17:40:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:39010 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbYKNWkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 17:40:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IC7E+t21wV+mJzsbFBnKCkRvCoFlbts1AMPkqR3FfBSkz0TbHU0JQQvMtBjTrqqBim
         cac/xkpAtqnwwHwW9H15PthUWufOn3rtPc/vNjoUew9DPVRW3SdAV+6Nzkt2c90r2efY
         1449R81CJaw/2mdl0qd3g7x/WIwOISaJGs5sc=
Message-ID: <b2cc26e40811141440m5f3616ecla243ad0df97b9d6f@mail.gmail.com>
Date: Fri, 14 Nov 2008 23:40:05 +0100
From: "Olaf van der Spek" <olafvdspek@gmail.com>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: Unix sockets via TCP on localhost: is TCP slower?
Cc: "David Miller" <davem@davemloft.net>, jrm8005@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081114210759.GX24654@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b2cc26e40811121520k711fa702u85e53bbc18b021a0@mail.gmail.com>
	 <3aaafc130811131619w3ba48a86u6c6e2af35f149bf1@mail.gmail.com>
	 <b2cc26e40811140051n4e821fddsc5504eedcccc9cdc@mail.gmail.com>
	 <20081114.005635.131100777.davem@davemloft.net>
	 <b2cc26e40811140109jfc6b0f3tf33a92afbff33e46@mail.gmail.com>
	 <20081114210759.GX24654@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 10:07 PM, Willy Tarreau <w@1wt.eu> wrote:
> I'm already wondering what problems you encounter with TCP performance
> on the loopback. I'm used to stress-test network proxies on the loopback

None. It's just a theoretical question.

> for quick tests when I don't want to boot 3 machines, and seeing that it's
> easy to connect/accept 100k sessions/s and forward about 20-30 Gbps between
> two processes on consumer-grade machines, I'm really doubting that your
> applications needs that much out of your database.

Hmm, those numbers look a lot better than the ones Chris Friesen
posted. He posted 334 mbyte/s for TCP and 1564 for Unix. That's a 4.7x
difference.

> If you're really so sensible to local traffic tunning, you can already
> set a very large MTU on your loopback, you can have very large windows
> between your applications so that very few ACKs are sent, etc... And
> BTW checksums are already not even computed. Loopback *is* fast, there's

That was my initial question. If the performance difference is
insignificant, that's fine with me.

> no need to crapify the whole stack with your "switch" to gain 5% more out
> of it.
>
> Anyway, if you can come up with patches which proves all of us wrong
> without weakening the code, I'm sure they could be accepted.

I'm sure too, but I won't.
