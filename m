Return-Path: <linux-kernel-owner+w=401wt.eu-S1754255AbYLHO4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbYLHO4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 09:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbYLHO4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 09:56:05 -0500
Received: from mx2.redhat.com ([66.187.237.31]:54781 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917AbYLHO4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 09:56:04 -0500
Message-ID: <493D357C.4090308@redhat.com>
Date: Mon, 08 Dec 2008 16:55:56 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, kvm-devel <kvm@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kvm: use modern cpumask primitives, no cpumask_t
 on stack
References: <200812072125.14416.rusty@rustcorp.com.au> <493BF144.9080106@redhat.com> <493D300A.6080805@sgi.com>
In-Reply-To: <493D300A.6080805@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
>> Since we're in a get_cpu() here, how about a per_cpu static cpumask
>> instead? I don't mind the inefficient fallback, just the duplication.
>>     
>
> One thing to note is that when CPUMASK_OFFSTACK=n, then alloc_cpumask_var
> returns a constant 1 and the duplicate code is not even compiled.
>   

I'm a lot more concerned about source duplication than binary 
duplication.  Rusty's patches resulted in a net reduction in 
duplication, so perhaps I should keep quiet about it.

-- 
error compiling committee.c: too many arguments to function

