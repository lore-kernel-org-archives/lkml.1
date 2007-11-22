Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbXKVASG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbXKVASG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 19:18:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbXKVARz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 19:17:55 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:47594 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbXKVARy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 19:17:54 -0500
Message-ID: <4744CAA4.50102@garzik.org>
Date: Wed, 21 Nov 2007 19:17:40 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: =?UTF-8?B?WU9TSElGVUpJIEhpZGVha2kgLyDlkInol6Toi7HmmI4=?= 
	<yoshfuji@linux-ipv6.org>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Herbert Xu <herbert@gondor.apana.org.au>,
       David Miller <davem@davemloft.net>
Subject: Re: [RFC/PATCH] SO_NO_CHECK for IPv6
References: <20071121124532.GA17263@havoc.gtf.org> <20071121.222051.94402865.yoshfuji@linux-ipv6.org>
In-Reply-To: <20071121.222051.94402865.yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

YOSHIFUJI Hideaki / 吉藤英明 wrote:
> In article <20071121124532.GA17263@havoc.gtf.org> (at Wed, 21 Nov 2007 07:45:32 -0500), Jeff Garzik <jeff@garzik.org> says:
> 
>> SO_NO_CHECK support for IPv6 appeared to be missing. This is presented,
>> based on a reading of net/ipv4/udp.c.
> 
> Disagree. UDP checksum is mandatory in IPv6.

Ah, you mean that I need to turn off UDP checksum on receive end as well 
in IPv6...  true.

For those interested, I am dealing with a UDP app that already does very 
strong checksumming and encryption, so additional software checksumming 
at the lower layers is quite simply a waste of CPU cycles.  Hardware 
checksumming is fine, as long as its "free."

	Jeff



