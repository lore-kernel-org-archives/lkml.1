Return-Path: <linux-kernel-owner+w=401wt.eu-S1754079AbYDGSmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbYDGSmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 14:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbYDGSmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 14:42:44 -0400
Received: from relay1.sgi.com ([192.48.171.29]:55696 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751300AbYDGSmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 14:42:44 -0400
Message-ID: <47FA6B22.9080900@sgi.com>
Date: Mon, 07 Apr 2008 11:42:42 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Paul Jackson <pj@sgi.com>, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] x86: add cpus_scnprintf function v2
References: <20080405012447.440875000@polaris-admin.engr.sgi.com> <20080407030421.0c3f8033.pj@sgi.com> <20080407081643.GC3066@elte.hu>
In-Reply-To: <20080407081643.GC3066@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Paul Jackson <pj@sgi.com> wrote:
> 
>> I still have some concerns with this cpus_scnprintf patch.
>>
>> I've taken them up with Mike offline for initial consideration.
>>
>> If others have questions, concerns or enthusiasms for this patch, Mike 
>> and I would be interested.
> 
> i dont mind the old patch either (which did an ugly temporary 
> allocation), if it keeps the ABI. I dont think it's a big deal, lets not 
> allow it to become a roadblock, and the overall goal of all these 
> patches [4096 CPU support in upstream Linux] is important and i'm 
> enthusiastic about that ;-)
> 
> 	Ingo

I have no stake in the ground for this either.  My assigned task was to
minimize the effect of bumping up the possible cpu count to a really
large amount.  This seemed to me to fall in this category.  A side goal
was to prepare for even larger cpu count systems.

An alternative that Paul had suggested was to introduce a new set of
file interfaces that produce the alternate format.  This would not
break existing interfaces and allow a transition, though how many
post-processors of the information would change is unclear.  Given
that fact, would the added code and complexity be worthwhile?

Thanks,
Mike
