Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbYHJGfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbYHJGfY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 02:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbYHJGfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 02:35:06 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:50030 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752133AbYHJGfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 02:35:05 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: davem@davemloft.net (David Miller)
Subject: Re: [RFC][PATCH 1/1] cxgb3i: cxgb3 iSCSI initiator
Cc: rdreier@cisco.com, jgarzik@pobox.com, swise@opengridcomputing.com,
       divy@chelsio.com, kxie@chelsio.com, netdev@vger.kernel.org,
       open-iscsi@googlegroups.com, michaelc@cs.wisc.edu, daisyc@us.ibm.com,
       wenxiong@us.ibm.com, bhua@us.ibm.com, dm@chelsio.com,
       leedom@chelsio.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Organization: Core
In-Reply-To: <20080809.224725.130946315.davem@davemloft.net>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev,apana.lists.os.linux.scsi
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1KS4VN-0000v1-00@gondolin.me.apana.org.au>
Date: Sun, 10 Aug 2008 14:34:17 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> wrote:
>
>> We already support offloads that break other features, eg large receive
>> offload breaks forwarding.  We deal with it.
> 
> We turn it off.  If I want to shape or filter one of these iSCSI
> connections can we turn it off?

Actually one of my TODO items is to restructure software LRO
so that we preserve the original packet headers while aggregating
the packets.  That would allow us to easily refragment them on
output for forwarding.

In other words LRO (at least the software variant) is not
fundamentally incompatible with forwarding.

I'd also like to encourage all hardware manufacturers considering
LRO support to provide a way for us to access the original headers
so that it doesn't have to be turned off for forwarding.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
