Return-Path: <linux-kernel-owner+w=401wt.eu-S1758286AbYECOnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758286AbYECOnH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 10:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755829AbYECOmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 10:42:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:56623 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538AbYECOmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 10:42:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=uxGnmDxlayzpn/eJ9Wd+BZaHOkd1PJ+98TWAlsC473x1yeOqEe4Za7pUfrKvns8beanAMZxglVIFq/FF4jb8ME6df8QdAusarmNIt5Zg0+CZsJjYLBWrcoJ1OAhc3yi0isDZxQk6vJOF6d/fo6IC4pLEFVTh0omUCwjpXroeTHY=
Date: Sat, 3 May 2008 22:46:49 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: xiyou.wangcong@gmail.com, herbert@gondor.apana.org.au,
       linux-kernel@vger.kernel.org, akpm@osdl.org, netdev@vger.kernel.org
Subject: Re: [Patch] (revised) net/xfrm/xfrm_policy.c: replace timer with
	delayed_work
Message-ID: <20080503144647.GF3986@hack>
References: <alpine.LFD.1.10.0804302355120.2940@localhost.localdomain> <20080501011123.GA4060@gondor.apana.org.au> <alpine.LFD.1.10.0805021323470.3349@localhost.localdomain> <20080502.165455.24687234.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080502.165455.24687234.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 04:54:55PM -0700, David Miller wrote:
>From: WANG Cong <xiyou.wangcong@gmail.com>
>Date: Fri, 2 May 2008 13:35:55 +0800 (CST)
>
>> 
>> As suggested by Herbert Xu, using workqueue is better than timer
>> for net/xfrm/xfrm_policy.c, so replace them with delayed_work.
>> And due to this change, we have to disable BH when trying to
>> lock.
>> 
>> Note that, this patch is not fully tested, so should be
>> in -mm first.
>> 
>> Signed-off-by: WANG Cong <wangcong@zeuux.org>
>
>Please let me know when these two patches have gotten some
>good testing.

Thanks for your comments, David!

I thought it can go into -mm so that many other people can help
me to test it. Since I didn't have the IPSec environment. ;(

I will try if I can set up one, then test it.

Thanks.
