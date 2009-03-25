Return-Path: <linux-kernel-owner+w=401wt.eu-S1756212AbZCYBEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbZCYBEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 21:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbZCYBEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 21:04:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:39886 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802AbZCYBEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 21:04:13 -0400
Message-ID: <49C982E6.9010005@kernel.org>
Date: Tue, 24 Mar 2009 18:03:34 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] Correct behaviour of irq affinity?
References: <200903241619.03517.rusty@rustcorp.com.au> <m1k56frt6e.fsf@fess.ebiederm.org> <200903251103.10249.rusty@rustcorp.com.au> <200903251129.19490.rusty@rustcorp.com.au>
In-Reply-To: <200903251129.19490.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Wednesday 25 March 2009 11:03:08 Rusty Russell wrote:
>> On Tuesday 24 March 2009 23:09:37 Eric W. Biederman wrote:
>>> cpu_mask_to_apic_id do not take cpu_online_map into account and should
>>> probably be fixed.  flat_cpu_mask_to_apicid was the one I could find.
>> Also the numaq apic.h.  I'll do an audit and send a patch.
> 
> Actually, numaq is just weird, so I'll assume it's correct.  I couldn't
> find any others.
> 
>> Yes, agree with Yinghai's fix.  I'll re-spin my patch on top of his.
> 
> But he already did it while I slept in.
> 

waiting for ingo to put that three into tip/master:

[PATCH 1/3] x86: fix set_extra_move_desc calling
[PATCH 2/3] x86: use default_cpu_mask_to_apicid for 64bit
[PATCH 3/3] x86: Correct behaviour of irq affinity -v2

YH
