Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266Ab0BYSY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 13:24:58 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58862 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933012Ab0BYSY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 13:24:56 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B86C05A.9010604@s5r6.in-berlin.de>
Date: Thu, 25 Feb 2010 19:24:26 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: Roel Kluin <roel.kluin@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
Subject: Re: Is kernel optimized with dead store removal?
References: <4B85A49E.6000803@gmail.com>	<19334.22971.970220.245930@pilspetsen.it.uu.se>	<4B8693B9.3060102@gmail.com> <19334.40943.479593.304961@pilspetsen.it.uu.se>
In-Reply-To: <19334.40943.479593.304961@pilspetsen.it.uu.se>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> It's only vulnerable if the data leaks to a less trusted domain.
> There is no domain crossing in your user-space example.
> In the kernel case, the domain crossing would be as I wrote: leaking
> recycled and uninitialized memory to user-space (and those leaks of
> uninitialized memory are frowned upon and quickly fixed when discovered).

Quickly fixed when discovered, but not necessary quickly discovered...
-- 
Stefan Richter
-=====-==-=- --=- ==--=
http://arcgraph.de/sr/
