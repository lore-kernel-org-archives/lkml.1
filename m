Return-Path: <linux-kernel-owner+w=401wt.eu-S1759006AbXEYHfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759006AbXEYHfp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 03:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbXEYHfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 03:35:39 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:3120 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbXEYHfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 03:35:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=e7BmWACwPZ6LxEAkcPg83CWBQmlkgBpSZNa9gdL7v50iBPUp3Aq77rs5wTNIDE8G2iz0ZV3Anu2CtJM2eA5URQgOsZ1Tzu/L7574l+EZEDvOtxgnL2+zx6+9q4E1n4yDbNIATFAoZUs+2brpyNkMHGvVWic+xerNyjK6muS0o1k=
Message-ID: <a781481a0705250035q2173234dp4f6cc4d103fced5c@mail.gmail.com>
Date: Fri, 25 May 2007 13:05:37 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] sched_clock(): cleanups
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <20070525072641.GA13025@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070525071005.GA6431@elte.hu>
	 <a781481a0705250022t3dec8f13u7c75d0ade40b0010@mail.gmail.com>
	 <20070525072512.GA12683@elte.hu> <20070525072641.GA13025@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/25/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> > > if (!f)
> > >     f = cpufreq_get(freq->cpu);
> > > if (!f)
> > >     f = tsc_khz;
> > >
> > > ?
> > >
> > > Something's not quite right here :-)
>
> ah, that's fine. It does this: 'try to give f a value', and then: 'if
> still no value then give it tsc_khz as a last resort)

Ugh, yes, didn't know cpufreq_get can return 0.

> call_r_s_f() still needs an urgent rerenaming though =B-)

So does "call_r_s_f_here()" :-)

Satyam
