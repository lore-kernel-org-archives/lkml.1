Return-Path: <linux-kernel-owner+w=401wt.eu-S1756962AbZLWUVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962AbZLWUVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 15:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbZLWUVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 15:21:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336AbZLWUVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 15:21:16 -0500
Message-ID: <4B327B90.2050403@redhat.com>
Date: Wed, 23 Dec 2009 22:20:32 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>, kvm@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, netdev@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>,
       Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
       torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Alacrityvm-devel] [GIT PULL] AlacrityVM guest drivers for 2.6.33
References: <4B1D4F29.8020309@gmail.com> <87637zdy9g.fsf@basil.nowhere.org>	<4B30E654.40702@codemonkey.ws>	<200912221701.56840.bzolnier@gmail.com>	<4B30F214.80206@codemonkey.ws> <20091223065129.GA19600@elte.hu>	<20091223101340.GC20539@basil.fritz.box> <4B31EF65.6070000@redhat.com> <4B325E33.8060407@gmail.com>
In-Reply-To: <4B325E33.8060407@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2009 08:15 PM, Gregory Haskins wrote:
> On 12/23/09 5:22 AM, Avi Kivity wrote:
>
>    
>> There was no attempt by Gregory to improve virtio-net.
>>      
> If you truly do not understand why your statement is utterly wrong at
> this point in the discussion, I feel sorry for you.  If you are trying
> to be purposely disingenuous, you should be ashamed of yourself.  In any
> case, your statement is demonstrably bogus, but you should already know
> this given that we talked about at least several times.
>    

There's no need to feel sorry for me, thanks.  There's no reason for me 
to be ashamed, either.  And there's no need to take the discussion to 
personal levels.  Please keep it technical.


> To refresh your memory: http://patchwork.kernel.org/patch/17428/
>    

This is not an attempt to improve virtio-net, it's an attempt to push 
vbus.  With this, virtio-net doesn't become any faster, since the 
greatest bottleneck is not removed, it remains in userspace.

If you wanted to improve virtio-net, you would port venet-host to the 
virtio-net guest/host interface, and port any secret sauce in 
venet(-guest) to virtio-net.  After that we could judge what vbus' 
contribution to the equation is.

> In case its not blatantly clear, which I would hope it would be to
> anyone that understands the problem space:  What that patch would do is
> allow an unmodified virtio-net to bridge to a vbus based virtio-net
> backend.  (Also note that this predates vhost-net by months (the date in
> that thread is 4/9/2009) in case you are next going to try to argue that
> it does nothing over vhost-net).
>    

Without the backend, it is useless.  It demonstrates vbus' flexibility 
quite well, but does nothing for virtio-net or its users, at least 
without a lot more work.

> This would mean that virtio-net would gain most of the benefits I have
> been advocating (fewer exits, cheaper exits, concurrent execution, etc).
>   So this would very much improve virtio-net indeed, given how poorly the
> current backend was performing.  I tried to convince the team to help me
> build it out to completion on multiple occasions, but that request was
> answered with "sorry, we are doing our own thing instead".  You can say
> that you didn't like my approach, since that is a subjective opinion.
> But to say that I didn't attempt to improve it is a flat out wrong, and
> I do not appreciate it.
>    

Cutting down on the rhetoric is more important than cutting down exits 
at this point in time.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

