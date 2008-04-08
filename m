Return-Path: <linux-kernel-owner+w=401wt.eu-S1756957AbYDHR7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957AbYDHR7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 13:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbYDHR7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 13:59:07 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:53375 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbYDHR7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 13:59:06 -0400
Date: Tue, 8 Apr 2008 19:59:02 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andy Whitcroft <apw@shadowen.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] checkpatch: nested structs
In-Reply-To: <20080408173548.GG17915@shadowen.org>
Message-ID: <alpine.LNX.1.10.0804081957000.2229@fbirervta.pbzchgretzou.qr>
References: <282cb105d4016d63a4c24442e244d157ef3aebe8.1207666528.git.jengelh@computergmbh.de> <20080408173548.GG17915@shadowen.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2008-04-08 19:35, Andy Whitcroft wrote:
>>  # on the line
>> -		if ($line =~ /}(?!(?:,|;|\)))\S/) {
>> +		if ($line =~ /}+(?!(?:,|;|\)))\S/) {
>>  			ERROR("space required after that close brace '}'\n" . $herecurr);
>>  		}
>
>If my eyes are not lying then you have added is a + after the first },
>as this is an unanchored match I would expect that to match in exactly
>the same places.  Hmm, well I guess that it would allow two or more close
>braces to abutt.  Can you give me an example of somethign which would
>require this?

+#define E(a, b, c, d) \
+       {.ip6 = { \
+               __constant_htonl(a), __constant_htonl(b), \
+               __constant_htonl(c), __constant_htonl(d), \
+       }}

static const struct union nf_inet_addr some_address = E(20010db8,0,13,17);
