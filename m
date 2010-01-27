Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008Ab0A0Juc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab0A0Juc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 04:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249Ab0A0Jub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 04:50:31 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:4835 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab0A0Ju3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 04:50:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=Vpg466dFhiG1nxWSYwI9ih6KkjyBUU7AIhfD0hBfMlGBgPRCUPKFoZL9fOgls4WHEP
         3JJI/z/+VOhjf5fQnbVQfJGediORUo4pJ+WXq4bJFGR00mPT0aHlNhuJaDTtgdTIQTR4
         C4besAFYdjtjFgYqAeVshW42SVlr07IfSOj7E=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Cc: lkml <linux-kernel@vger.kernel.org>, "A Rojas" <nqn1976list@gmail.com>,
       "Hugh Dickins" <hugh.dickins@tiscali.co.uk>,
       "A. Boulan" <arnaud.boulan@libertysurf.fr>, michael@reinelt.co.at,
       jcnengel@googlemail.com, rientjes@google.com, earny@net4u.de,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Eric Anholt" <eric@anholt.net>,
       "Chris Wilson" <chris@chris-wilson.co.uk>
Subject: Re: OOM-Killer kills too much with 2.6.32.2
References: <20100126183412.6AC9.A69D9226@jp.fujitsu.com>
 <op.u646z3e7asvm2a@kedge> <20100127091354.6ACF.A69D9226@jp.fujitsu.com>
Date: Wed, 27 Jan 2010 10:53:03 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From: "Roman Jarosz" <kedgedev@gmail.com>
Message-ID: <op.u66q2pjuasvm2a@kedge>
In-Reply-To: <20100127091354.6ACF.A69D9226@jp.fujitsu.com>
User-Agent: Opera Mail/10.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jan 2010 01:14:44 +0100, KOSAKI Motohiro  
<kosaki.motohiro@jp.fujitsu.com> wrote:

>> > -	mapping_set_gfp_mask(obj->filp->f_path.dentry->d_inode->i_mapping,
>> > -			     GFP_HIGHUSER |
>> > -			     __GFP_COLD |
>> > -			     __GFP_FS |
>> > -			     __GFP_RECLAIMABLE |
>> > -			     __GFP_NORETRY |
>> > -			     __GFP_NOWARN |
>> > -			     __GFP_NOMEMALLOC);
>> > -
>> >  	kref_init(&obj->refcount);
>> >  	kref_init(&obj->handlecount);
>> >  	obj->size = size;
>>
>> I've applied this patch and I'm testing it right now.
>> Btw. what this patch will do from user(my) point of view?
>
> OOM Killer disappear :)

Looks like the patch works... no oom kills so far.

Thanks!
