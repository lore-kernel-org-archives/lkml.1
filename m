Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbZLBJww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbZLBJww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 04:52:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbZLBJwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 04:52:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:38271 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbZLBJwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 04:52:51 -0500
Message-ID: <4B16388F.90707@kernel.org>
Date: Wed, 02 Dec 2009 18:51:11 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: tglx@linutronix.de, mingo@elte.hu, avi@redhat.com, peterz@infradead.org,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] sched: refactor try_to_wake_up()
References: <1259726212-30259-1-git-send-email-tj@kernel.org>	 <1259726212-30259-4-git-send-email-tj@kernel.org> <1259744733.6028.233.camel@marge.simson.net>
In-Reply-To: <1259744733.6028.233.camel@marge.simson.net>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/02/2009 06:05 PM, Mike Galbraith wrote:
> On Wed, 2009-12-02 at 12:56 +0900, Tejun Heo wrote:
>> Factor ttwu_activate() and ttwu_woken_up() out of try_to_wake_up().
> 
> Nit: ttwu_woken_up() sounds decidedly strange to my ear. Perhaps
> ttwu_post_activation()?

Sure, I can rename it.

> As a $.02 comment, factoring here doesn't look nice, reader scrolls
> around whereas he currently sees all the why/wherefore at a glance.
> Needing to pass three booleans for stats also looks bad.

The three bools aren't the prettiest thing in the world but I couldn't
prevent gcc from re-evaluating expressions without those.

> I think it would _look_ better with the thing just
> duplicated/stripped down and called what it is,
> sched_notifier_wakeup() or such.

Sorry, I'm not following.  Can you elaborate a bit?

> Which leaves growth in it's wake though...
>
>> +/**
>>   * try_to_wake_up - wake up a thread
>>   * @p: the to-be-woken-up thread
> 
> Nit: thread to be awakened sounds better.

Will update.

Thanks.

-- 
tejun
