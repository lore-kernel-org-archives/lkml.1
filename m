Return-Path: <linux-kernel-owner+w=401wt.eu-S1755124AbZALRp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbZALRp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 12:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbZALRpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 12:45:06 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:6264 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbZALRpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 12:45:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=oRDwRtORGrU1PK7aj5gNnyAfF+6SnAQpClD8JFlStjigI8z5MBiJOEuOmuZvGxDo0x
         Ga9jsN1ljlqcLVr2tIz9OvtCHPf2U+6gj3l6vwrk4y8W8Ud/K8Y8sdS0sfO65jfwqQBC
         aG2kxZrCjCaI196jGJhSm5TeGdutBf4toETL4=
Message-ID: <e9c3a7c20901120945r2728e6d3oc9237249d748f8dd@mail.gmail.com>
Date: Mon, 12 Jan 2009 10:45:02 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Subject: Re: [GIT PULL, resend] async_tx/dmaengine update for 2.6.29
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, hskinnemoen@atmel.com,
       maciej.sosnowski@intel.com, g.liakhovetski@gmx.de, sfr@canb.auug.org.au,
       netdev@vger.kernel.org, s.hauer@pengutronix.de,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20090112121539.GA6058@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090112121539.GA6058@gondor.apana.org.au>
X-Google-Sender-Auth: 67346db46510f5cd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 5:15 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Dan Williams <dan.j.williams@intel.com> wrote:
>>
>> net/core/dev.c                        |  149 +------
>> net/ipv4/tcp.c                        |    5 +-
>> net/ipv4/tcp_input.c                  |    2 +-
>> net/ipv4/tcp_ipv4.c                   |    2 +-
>> net/ipv6/tcp_ipv6.c                   |    2 +-
>
> Wouldn't it be better for these changes to go through the net
> tree?
>

It was awkward to separate the reformatting of the core api from its
users.  In this exceptional case these changes were limited to areas
inside #ifdef CONFIG_DMA_ENGINE/CONFIG_NET_DMA.

In general, Maciej and I send purely incremental patches through the
net tree [1].

Regards,
Dan

[1]: http://git.kernel.org/?p=linux/kernel/git/davem/net-2.6.git;a=commitdiff;h=649274d993212e7c23c0cb734572c2311c200872
