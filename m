Return-Path: <linux-kernel-owner+w=401wt.eu-S1752599AbYI2Odc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbYI2Odc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 10:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbYI2OdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 10:33:24 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49583 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751328AbYI2OdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 10:33:23 -0400
Message-ID: <48E0E73A.40803@sgi.com>
Date: Mon, 29 Sep 2008 07:33:30 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, David Miller <davem@davemloft.net>,
       Alan.Brunelle@hp.com, tglx@linutronix.de, rjw@sisk.pl,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kernel-testers@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, arjan@linux.intel.com,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -	bisected
References: <alpine.LFD.1.10.0808251344250.3363@nehalem.linux-foundation.org> <200809251150.26760.rusty@rustcorp.com.au> <alpine.LFD.1.10.0809250836270.3265@nehalem.linux-foundation.org> <200809261525.30258.rusty@rustcorp.com.au> <48DC78F2.8060400@sgi.com> <20080927191653.GB18619@elte.hu>
In-Reply-To: <20080927191653.GB18619@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> Hi Rusty,
>>
>> I've gotten some good traction on the changes in the following patch.  
>> About 30% of the kernel is compiling right now and I'm picking up 
>> errors and warnings as I'm going along.  I think it's doing most of 
>> what we need.  Attempting to hide the cpumask struct definition caused 
>> all kinds of problems with the inline functions and statically 
>> declaring cpumask's.
>>
>> (The following patch is a combination of all the changes to cpumask.h 
>> with the header from the first patch.  I'll send you a complete copy 
>> in separate email.)
> 
> could you please send whatever .c changes you have already, so that we 
> can have a look at how the end result will look like? Doesnt have to 
> build, i'm just curious about how it looks like in practice, 
> semantically.
> 
> 	Ingo


I will, and the full "allyesconfig" does compile.  And it's basically a
benign change in that the functionality is still the same.  I'm currently
reordering it a bit to clean it up.

Thanks,
Mike
