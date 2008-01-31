Return-Path: <linux-kernel-owner+w=401wt.eu-S1756466AbYAaAmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466AbYAaAmP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 19:42:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbYAaAl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 19:41:59 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:37702 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752785AbYAaAl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 19:41:58 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: shemminger@linux-foundation.org (Stephen Hemminger)
Subject: Re: Change In sk_buff structure in 2.6.22 kernel
Cc: pvjuliet@gmail.com, linux-kernel@vger.kernel.org
Organization: Core
In-Reply-To: <20080129222729.1f4fef95@deepthought>
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1JKNUz-0000jh-00@gondolin.me.apana.org.au>
Date: Thu, 31 Jan 2008 11:41:49 +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger <shemminger@linux-foundation.org> wrote:
>
>> Networking code and drivers are supposed to use skb->transport_header,
>> skb->network_header, and skb->skb_mac_header.
>> But when I am trying to access fields of TCP using the code
>> struct tcphdr *tcp = skb->transport_header;
>> tcp->   //accessing proper field
>> It is not accessing the value properly ...
>> Can anyone please help me ???
>
> Use the new accessor functions skb_transport_header(skb), skb_network_header(skb),

There are also protocol helpers like tcp_hdr.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
