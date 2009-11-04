Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbZKDCeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbZKDCeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 21:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738AbZKDCeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 21:34:11 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49523
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750751AbZKDCeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 21:34:10 -0500
Date: Tue, 03 Nov 2009 18:34:35 -0800 (PST)
Message-Id: <20091103.183435.209882374.davem@davemloft.net>
To: Valdis.Kletnieks@vt.edu
Cc: ilpo.jarvinen@helsinki.fi, gilad@codefidence.com, eric.dumazet@gmail.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, ori@comsleep.com
Subject: Re: 2.6.32-rc5-mmotm1101 - kernel BUG at net/ipv4/tcp_input.c:3707!
From: David Miller <davem@davemloft.net>
In-Reply-To: <7916.1257300093@turing-police.cc.vt.edu>
References: <4AF08292.7090102@codefidence.com>
	<Pine.LNX.4.64.0911032330090.3488@melkinkari.cs.Helsinki.FI>
	<7916.1257300093@turing-police.cc.vt.edu>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valdis.Kletnieks@vt.edu
Date: Tue, 03 Nov 2009 21:01:33 -0500

> Why was this blowing chunks in the IPv6 when I was making an IPv4 connection
> then? I just noticed that. My fetchmail can't make an IPv6 TCP connection to
> our IMAP server because the server isn't v6-enabled yet.  And although I
> contact our DNS over IPv6, but that's UDP not TCP.

Many things IPV6 capable will go through the IPV4 compat
path of the IPV6 stack, depending upon how listening sockets
configure themselves etc.
