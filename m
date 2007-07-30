Return-Path: <linux-kernel-owner+w=401wt.eu-S1760731AbXG3M2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760731AbXG3M2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 08:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbXG3M2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 08:28:40 -0400
Received: from stinky.trash.net ([213.144.137.162]:36197 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbXG3M2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 08:28:39 -0400
Message-ID: <46ADD962.4040700@trash.net>
Date: Mon, 30 Jul 2007 14:28:18 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netfilter-devel@lists.netfilter.org, coreteam@netfilter.org,
       Rusty Russell <rusty@rustcorp.com.au>, Marc Boucher <marc@mbsi.ca>,
       James Morris <jmorris@namei.org>, Harald Welte <laforge@netfilter.org>,
       Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH][netfilter] Avoid a possible NULL pointer deref in recent_seq_open()
References: <200707290308.45464.jesper.juhl@gmail.com>
In-Reply-To: <200707290308.45464.jesper.juhl@gmail.com>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> There is a small problem in
>  net/ipv4/netfilter/ipt_recent.c::recent_seq_open().
> 
> If the call to seq_open() returns != 0 then the code calls 
> kfree(st) but then on the very next line proceeds to 
> dereference the pointer - not good.


Applied, thanks Jesper.

