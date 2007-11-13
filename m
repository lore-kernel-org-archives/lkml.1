Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbXKMQDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbXKMQDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 11:03:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbXKMQD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 11:03:28 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:30265 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466AbXKMQD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 11:03:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=mlmiWteGf+0+3fFR3SMuiaWfX4nTi2pSan7YSxv0+D7hE4OwGIRZbc1HnqUa5Dkz4BsIxct4bxTpmXO9YWo/CuIJR1J9WcoGaxBLR4kig9ockiyhZ0xPVxnMeXtM9TI8jxVS8WHDKYC4LS1NEJnq1LEUAT5R+8iva/L33zETgf4=
Message-ID: <2c0942db0711130803o4f0048d6l6631349aa8987681@mail.gmail.com>
Date: Tue, 13 Nov 2007 08:03:24 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: Shish <shish@shishnet.org>
Subject: Re: Weird network problems with 2.6.23-rc2
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20070811083959.305b0421.shish@shishnet.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070811083959.305b0421.shish@shishnet.org>
X-Google-Sender-Auth: 55c44467a4e6bcc9
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello there Shish,

On Aug 10, 2007 11:39 PM, Shish <shish@shishnet.org> wrote:
> Something seems to have broken in 2.6.23-rc2, and I'm not sure what, or
> where I should look for further debugging. The info I have:
>
> On my 2.6.23-rc2 desktop, things run fine.
>
> On my test server, built from the same source tree, networking goes
> strange every few minutes, with the following symptoms:
>
> o) running ping against the server, the first ping goes through;
> further pings go AWOL until about icmp_seq=30, when I get 4-5 icmp
> replies (marked as DUP!), then no pings for a while, then dups, and so
> on.
>
> o) the server doesn't see ARP replies. According to tcpdump, the server
> will send eg "who has 192.168.0.2? tell 192.168.0.1"; the client in
> question will recieve the packet and send a response, but nothing shows
> up in the server-side tcpdump.
>
> o) after a few minutes of random network troubles, everything will work
> fine again, (ping is normal, arp replies are seen, tcp sessions work)
> for a few minutes.
>
> o) The server's dmesg shows lots of "short udp packet" messages
>
> o) ifdown then ifup'ing the interfaces fixes things, temporarily.
>
> Reverting to 2.6.22, everything seems to be running fine (but no lguest,
> which is what I came for :( )
>
> I've also tried with the latest code from git, the behaviour is the same
> as 2.6.23-rc2.

Several questions. What network card do you have on your server? Is
this still reproducible with the latest code from git? If so, it would
be extremely helpful if you could do a bisect between 2.6.22 and
2.6.23-rc2. Feel free to ask for help if you need it.

Ray
