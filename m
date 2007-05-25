Return-Path: <linux-kernel-owner+w=401wt.eu-S1753790AbXEYHWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbXEYHWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 03:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911AbXEYHWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 03:22:48 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:1077 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbXEYHWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 03:22:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uDkgOj1VrW6XwQBr2h43skyKg44FrrM7Hq8YOjwgR1hM0aUKBR9ClkhxdIddPy1wdCZJjHG9hL2BnCLoFQ3CniN7VDOfmdfJxVu2QDKeqBclgHPi+K8CaeS5o6yES7A2hWOvINCrtI+zLpW7Sz9A5xH3uBHmoquaiNmewNRkS2U=
Message-ID: <a781481a0705250022t3dec8f13u7c75d0ade40b0010@mail.gmail.com>
Date: Fri, 25 May 2007 12:52:43 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] sched_clock(): cleanups
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <20070525071005.GA6431@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070525071005.GA6431@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On 5/25/07, Ingo Molnar <mingo@elte.hu> wrote:
> [...]
> @@ -137,6 +147,7 @@ static void call_r_s_f(void *arg)
>  {
>         struct cpufreq_freqs *freq = arg;
>         unsigned f = freq->new;
> +
>         if (!f)
>                 f = cpufreq_get(freq->cpu);
>         if (!f)

if (!f)
	f = cpufreq_get(freq->cpu);
if (!f)
	f = tsc_khz;

?

Something's not quite right here :-)

Satyam
