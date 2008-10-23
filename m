Return-Path: <linux-kernel-owner+w=401wt.eu-S1754964AbYJWPTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964AbYJWPTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 11:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbYJWPT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 11:19:27 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39995 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751254AbYJWPT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 11:19:26 -0400
Message-ID: <49009639.3050603@sgi.com>
Date: Thu, 23 Oct 2008 08:20:25 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [bug #2] Re: [PATCH 00/35] cpumask: Replace cpumask_t with struct
 cpumask
References: <20081023020826.051012000@polaris-admin.engr.sgi.com> <20081023125529.GA18327@elte.hu> <20081023142025.GA18804@elte.hu> <200810240201.15037.rusty@rustcorp.com.au>
In-Reply-To: <200810240201.15037.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Friday 24 October 2008 01:20:25 Ingo Molnar wrote:
>> Thomas has started a -tip cross-build test, and there's massive
>> cross-build failures as well due to the cpumask changes:
> 
> Yes.  linux-next reported the same thing.  I've backed out various arch 
> changes for this reason.
> 
>> it seems to me that this commit is massively borked:
>>
>>   4a792c2: cpumask: make CONFIG_NR_CPUS always valid
> 
> Yep.  This is the big one I dropped.  There are a few others; Mike is just 
> porting the changes across to your tree now.
> 
> Cheers,
> Rusty.

Hi Ingo,

It would seem easier to back out previous patches and apply the replacements.
Does this work for you?

Thanks,
Mike
