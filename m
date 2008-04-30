Return-Path: <linux-kernel-owner+w=401wt.eu-S1758681AbYD3QD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758681AbYD3QD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 12:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762085AbYD3QDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 12:03:01 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:23645 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762003AbYD3QC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 12:02:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:x-x-sender:to:cc:subject:in-reply-to:message-id:references:user-agent:mime-version:content-type:from;
        b=kK5S1NVt2+vPhqaHbzchwzppC4Mu0xUXM/GEqxkE1l4w7uS45FFsC8HD9cvu/AZdPcnKaIfH/bdWiY6anigDAYkpbBiXyjUPfqqQkNqmsFKUPhmLe9IhtdIOJk+yc+cx9aRD4rragdUdo70npq3FO5NZwruejuMjzYWjJbdLF4Y=
Date: Thu, 1 May 2008 00:06:55 +0800 (CST)
X-X-Sender: wangcong@localhost.localdomain
To: Herbert Xu <herbert@gondor.apana.org.au>
cc: WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
       davem@davemloft.net, akpm@osdl.org, netdev@vger.kernel.org
Subject: Re: [Patch]net/xfrm/xfrm_policy.c: replace timer with delayed_work
In-Reply-To: <20080428151342.GA12007@gondor.apana.org.au>
Message-ID: <alpine.LFD.1.10.0804302355120.2940@localhost.localdomain>
References: <20080216.235534.237382205.xiyou.wangcong@gmail.com> <20080427011809.GA662@gondor.apana.org.au> <20080428.225312.58450957.xiyou.wangcong@gmail.com> <20080428151342.GA12007@gondor.apana.org.au>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
From: WANG Cong <xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008, Herbert Xu wrote:

> On Mon, Apr 28, 2008 at 10:53:12PM +0800, WANG Cong wrote:
>>
>> Do you mean ->lock of struct xfrm_policy?
>> OK. I will recook these two patches soon.
>
> Yep.

Hi, Herbert.

I referenced the book Linux Device Drivers, it is said that
the work function in workqueue can sleep, that is to say, it only
works in process context, so we don't need the disable the lock
in softirq, which is interrupt context, right?

Please teach me if I missed some obvious things. ;-)

Thanks.

