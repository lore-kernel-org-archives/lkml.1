Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab0BQVSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 16:18:00 -0500
Received: from mail.lang.hm ([64.81.33.126]:36646 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756496Ab0BQVR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 16:17:59 -0500
Date: Wed, 17 Feb 2010 13:17:43 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Nick Bowler <nbowler@elliptictech.com>
cc: Volker Armin Hemmann <volkerarmin@googlemail.com>,
       Kyle Moffett <kyle@moffetthome.net>,
       Rudy Zijlstra <rudy@grumpydevil.homelinux.org>,
       Neil Brown <neilb@suse.de>,
       "Mr. James W. Laferriere" <babydr@baby-dragons.com>,
       Bill Davidsen <davidsen@tmr.com>, Michael Evans <mjevans1983@gmail.com>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: Linux mdadm superblock question.
In-Reply-To: <20100217185105.GA15614@emergent.ellipticsemi.com>
Message-ID: <alpine.DEB.2.00.1002171317080.4721@asgard.lang.hm>
References: <201002140251.59668.volkerarmin@googlemail.com> <alpine.DEB.2.00.1002170932010.4721@asgard.lang.hm> <20100217181016.GA14983@emergent.ellipticsemi.com> <201002171927.07051.volkerarmin@googlemail.com> <20100217183703.GA15446@emergent.ellipticsemi.com>
 <alpine.DEB.2.00.1002171040350.4721@asgard.lang.hm> <20100217185105.GA15614@emergent.ellipticsemi.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Feb 2010, Nick Bowler wrote:

> On 10:41 Wed 17 Feb     , david@lang.hm wrote:
>> On Wed, 17 Feb 2010, Nick Bowler wrote:
>>> It takes about half a second for mdadm to assemble my root array, is
>>> that what you're referring to?
>>>
>>> I assume that kernel auto-assembly is no faster, although I've never
>>> used it.  Regardless, half a second isn't very long to wait.
>>
>> If you are aiming for a 5-second boot time it's 10% of your total boot
>> time. That's a lot for a feature that's not needed.
>
> Only if the kernel auto-assembly takes zero time, which it obviously
> does not.

the assembly time would probably be the same, but the initramfs being 
proposed did not include that time either.

David Lang
