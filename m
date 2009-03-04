Return-Path: <linux-kernel-owner+w=401wt.eu-S1755069AbZCDATS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbZCDATS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 19:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbZCDATE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 19:19:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44106 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbZCDATD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 19:19:03 -0500
Message-ID: <49ADC80F.6010200@zytor.com>
Date: Tue, 03 Mar 2009 16:15:11 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       x86@kernel.org, linux-kernel@vger.kernel.org, jeremy@goop.org,
       cpw@sgi.com, nickpiggin@yahoo.com.au, ink@jurassic.park.msu.ru
Subject: Re: [PATCHSET x86/core/percpu] improve the first percpu  chunk allocation
References: <1235445101-7882-1-git-send-email-tj@kernel.org> <20090224141217.GA17287@elte.hu> <49A40624.4000100@kernel.org> <200903041033.09502.rusty@rustcorp.com.au>
In-Reply-To: <200903041033.09502.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Wednesday 25 February 2009 01:07:24 Tejun Heo wrote:
>> it always
>> saves a 2MB TLB entry for all the non-NUMA machines out there.
> 
> Note that everyone keeps talking about "a" TLB entry; I wanted to make
> sure (esp. for those of us reading from the sidelines), it's not: it's
> up to num_possible_cpus() TLB entries.  Of course, many paths won't access
> other CPU's data, but it'd be interesting (and pretty easy) to actually
> instrument how rare this is...
> 

Actually it's up to the number of actual CPUs in the system... obviously 
there isn't any data allocated for non-present CPUs.

	-hpa
