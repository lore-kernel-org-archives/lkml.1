Return-Path: <linux-kernel-owner+w=401wt.eu-S932586AbYEHR5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586AbYEHR5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 13:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765525AbYEHR5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 13:57:11 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28957 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765307AbYEHR5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 13:57:06 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5291"; a="2989006"
Message-ID: <48233EEB.1010807@qualcomm.com>
Date: Thu, 08 May 2008 10:56:59 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Jackson <pj@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       menage@google.com, seto.hidetoshi@jp.fujitsu.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, oleg@tv-sign.ru,
       rostedt@goodmis.org, rientjes@google.com
Subject: Re: Reverting per-cpuset "system" (IRQ affinity) patch
References: <48210101.1070205@google.com>	 <20080506183138.546f42d9.akpm@linux-foundation.org>	 <20080506204054.564fff32.pj@sgi.com> <20080506223859.0b4fa876.pj@sgi.com>	 <20080506204444.f4c38d0a.akpm@linux-foundation.org>	 <20080506225228.d42630cf.pj@sgi.com> <1210142681.13978.166.camel@twins>
In-Reply-To: <1210142681.13978.166.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Peter Zijlstra wrote:
> On Tue, 2008-05-06 at 22:52 -0500, Paul Jackson wrote:
>> Andrew wrote:
>>> Don't worry about it.  I sorted out things locally and I expect that
>>> Stephen will be able to as well.
>> Ok ...
>>
>> I hesitate more than I should some times to NAQ patches,
>> but the more I think about this one, the less willing I
>> am to have a per-cpuset file called "system".
>>
>> I'm not sure what "sorted out" means ... I'll wait and see.
>>
>> Thanks, Andrew.
>>
>> Sorry, Max, Peter and Ingo ... we really had not arrived at
>> agreement on this one.
> 
> No problem, I've been meaning to redo this whole series but somehow
> stuff got in the way and I never got around to it :-/

I'm actually totally surprised that it got in. Ingo applied Peter's initial
patch to his sched-devel tree but then ignored follow up patches with fixes
and stuff from me (I'm assuming that was  because we started discussion
alternative options).
Anyway, my vote goes for reverting these series.

Max
