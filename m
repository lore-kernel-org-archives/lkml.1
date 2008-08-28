Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302AbYH1T5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbYH1T5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 15:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922AbYH1T45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 15:56:57 -0400
Received: from relay2.globalproof.net ([194.146.153.25]:54703 "EHLO
	relay2.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482AbYH1T44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 15:56:56 -0400
From: Denys Fedoryshchenko <denys@visp.net.lb>
Organization: Virtual ISP
To: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: loaded router, excessive getnstimeofday in oprofile
Date: Thu, 28 Aug 2008 22:55:29 +0300
User-Agent: KMail/1.9.9
Cc: Andi Kleen <andi@firstfloor.org>, Joe Malicki <jmalicki@metacarta.com>,
       David Miller <davem@davemloft.net>, johnpol@2ka.mipt.ru,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       juhlenko@akamai.com, sammy@sammy.net
References: <20080827.201020.17601834.davem@davemloft.net> <200808282225.57535.denys@visp.net.lb> <48B6FE6C.4080905@cosmosbay.com>
In-Reply-To: <48B6FE6C.4080905@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808282255.29640.denys@visp.net.lb>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 August 2008, Eric Dumazet wrote:
> OK, please try oprofile with call graph analysis.
I did already. Even because most of programs (except ripd/zebra) can be 
killed, and i kill them, it doesn't change almost anything.

it seems heavy things causing instability:

1)HTB (resolution can be lowered to improve performance, i will try Jarek 
patch soon)
2)ocassionally ping/tcpdump other SO_TIMESTAMP users
3)Probably softlockup detection. Disabled already, i will come back to it 
soon, if it is required.

One of other issues i notice - "CACHE MISS" cause maybe almost 5-10% in 
oprofile in u32, but i am not sure it is interesting subject to discuss. I 
have to optimize all my iproute2 rules first.

