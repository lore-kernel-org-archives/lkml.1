Return-Path: <linux-kernel-owner+w=401wt.eu-S1763369AbZD1R1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763369AbZD1R1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 13:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755861AbZD1R1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 13:27:00 -0400
Received: from mail.lang.hm ([64.81.33.126]:49102 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755540AbZD1R07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 13:26:59 -0400
Date: Tue, 28 Apr 2009 10:23:39 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Tejun Heo <tj@kernel.org>, Dave Airlie <airlied@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: kms in defconfig
In-Reply-To: <alpine.LFD.2.00.0904281002570.22156@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0904281019580.17268@asgard.lang.hm>
References: <21d7e9970904270121s1c58365bqc8933f8a3ffc5f1a@mail.gmail.com>  <20090427083935.GA20941@elte.hu> <21d7e9970904270156v54a6483fs20d5b31c97a1d482@mail.gmail.com> <49F65FA2.4010603@kernel.org> <alpine.LFD.2.00.0904271852510.22156@localhost.localdomain>
 <alpine.DEB.1.10.0904280946210.17268@asgard.lang.hm> <alpine.LFD.2.00.0904281002570.22156@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009, Linus Torvalds wrote:

> On Tue, 28 Apr 2009, david@lang.hm wrote:
>>
>> as a end-user creating my own configs, I use the defaults as a guide to
>> understand when something moves from "we think it's a good idea" to "things
>> really need this"
>
> I'm not talking about the defaults in the Kconfig files themselves, I'm
> talking about the millions of "*_defconfig" files that have tons of random
> default values.

Ok, I misunderstood.

>> If a tool was available to detect the hardware and create a config tailored
>> for the box, this use for a default config would go away
>
> Yeah, I've wished for that.
>
> Although I personally don't find that the actual hardware to be the
> biggest issue (since there are usually just a few options for that, and
> they are mostly not confusing). Instead, it's the issues about knowing
> which software components (netfilter, filesystems, auditing, POSIX ACL's)
> that you really want.

yes and no, getting a config that will boot on your system can sometimes 
be 'interesting' (mapping hardware -> config option for example), but 
should be able to be automated.

the other items that you mention (netfilter, etc) are actually the easier 
ones to deal with (you know what you want), and also the place where it's 
impossible to detect what's wanted.

> It tends to be easy to just enable them all, but if you want a nice
> efficient build, that's very much against the point.
>
> So having some kind of (probably inevitably fairly complex) script that
> you could run to get a config would be good. The problem is that the
> script would need to be distributed with the kernel, yet it would often
> also have some nasty distro issues.

I've seen people talk about creating such tools, but the responses that 
I've seen have tended to discourage them.

David Lang
