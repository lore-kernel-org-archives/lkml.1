Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbYEaUZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbYEaUZe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 16:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbYEaUZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 16:25:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:41783 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbYEaUZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 16:25:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RPmNDXpi9PQI6iq5MhiFuWBQasJCEX7QQOzb5DkjfRJzTms/j7hDtE9AaNMolbDR0qIux5Jz1jk9aotpYYery3xLU9jy7US8UIgTcLWJd1o2fJ3UeDlAOBIu0rFzvCBVhperr0r3WTD3FJeXQP7LVNE2E4H8qzW0YsNGBqj65/k=
Message-ID: <a01a16b50805311325w7f58ca69h93d02af9bc28d2ea@mail.gmail.com>
Date: Sat, 31 May 2008 22:25:22 +0200
From: "=?UTF-8?Q?H=C3=A5kon_L=C3=B8vdal?=" <hlovdal@gmail.com>
To: "=?UTF-8?Q?Ilpo_J=C3=A4rvinen?=" <ilpo.jarvinen@helsinki.fi>
Subject: Re: [bug] stuck localhost TCP connections, v2.6.26-rc3+
Cc: LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0805312119270.2672@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <20080526115628.GA31316@elte.hu> <1211966834.12349.62.camel@twins>
	 <a01a16b50805310725x4f1c375ep2d091bb044ac0787@mail.gmail.com>
	 <Pine.LNX.4.64.0805311839540.2657@wrl-59.cs.helsinki.fi>
	 <484191BD.8000904@gmail.com>
	 <Pine.LNX.4.64.0805312119270.2672@wrl-59.cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m4VKPoHl032423

2008/5/31 Ilpo JÃ¤rvinen <ilpo.jarvinen@helsinki.fi>:> Ok, like you said, this is not exactly the same, though it might be due to> the same bug. In Ingo's case both endpoints were doing pretty healtily,> with periodic window probes as expected. In your case TCP is not doing> window probes but got that interesting RTO value.>> So you had that '-' earlier and you checked at that time but the> connection is now already dead?
This is only from checking after the connection was dead. By the way,I just had to remotely reboot the new machine because the windowmanager locked up, however the old PC are still listing the defunctconnections after this.

> :-(, I would some much liked to see what they were doing.
I can of course keep on copying for testing purposes, but then I would like tobe able to dump only that single tcp connection, any tips of how to do that?I found nothing specific in the manuals of wireshark and tcpdump. Of courseit is possible to capture everything and filter afterwards, but since I will betransferring lots of data the logs will get huge and I would not like to haveeven additional traffic inside...

> These 7C/D... certainly seem strange values. Which TCP variant you have in> use (cat /proc/sys/net/ipv4/tcp_congestion_control)? It seems that vegas,> veno and yeah at least contain 0x7fffffff there for some rtt, which could> perhaps somehow leak.
I have not done any specific selection myself. On old_pc: bic, new_pc: cubic.
BR HÃ¥kon LÃ¸vdalÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
