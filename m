Return-Path: <linux-kernel-owner+w=401wt.eu-S1756649AbZFILU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbZFILU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 07:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754973AbZFILUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 07:20:16 -0400
Received: from khc.piap.pl ([195.187.100.11]:57000 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222AbZFILUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 07:20:15 -0400
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Subject: Re: [Security, resend] Instant crash with rtl8169 and large packets
References: <4A2D1147.8020101@msgid.tls.msk.ru> <4A2D1FE4.5030100@gmail.com>
	<4A2D25F6.9080300@msgid.tls.msk.ru> <4A2D2906.6090002@gmail.com>
	<4A2D301D.9040301@msgid.tls.msk.ru> <4A2D3568.6010901@gmail.com>
	<4A2D3BC6.3040904@msgid.tls.msk.ru> <4A2D4AA7.6020204@gmail.com>
	<4A2D6D0C.6060206@msgid.tls.msk.ru> <4A2D7FFE.9070701@cosmosbay.com>
	<4A2D825B.6090409@msgid.tls.msk.ru>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 09 Jun 2009 13:20:14 +0200
In-Reply-To: <4A2D825B.6090409@msgid.tls.msk.ru> (Michael Tokarev's message of "Tue\, 09 Jun 2009 01\:27\:55 +0400")
Message-ID: <m3my8hlklt.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev <mjt@tls.msk.ru> writes:

> Well, the performance is quite good -- 935Mb/sec according to iperf
> for TCP.  With UDP I got 1.05Gb/sec, but CPU usage is 100% during
> all test time (for TCP test the CPU is in use for less than 5%).

BTW you may want to try pktgen for TX bandwidth tests (a kernel module).
In "clone" mode a slow IXP425 (ARM XScale) 533 MHz + Intel's 82541xx
E1000 chip are able to transmit 1500-byte packets at full gigabit speed.
-- 
Krzysztof Halasa
