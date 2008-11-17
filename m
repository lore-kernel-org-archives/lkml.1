Return-Path: <linux-kernel-owner+w=401wt.eu-S1752865AbYKQOcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbYKQOcy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 09:32:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYKQOcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 09:32:46 -0500
Received: from gate.crashing.org ([63.228.1.57]:47954 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbYKQOcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 09:32:45 -0500
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Message-Id: <7D365ECF-C4B1-445C-85F9-36D4C9808E44@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <491F107E.4070702@redhat.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [PATCH][for 2.6.28] Remove -mno-spe flags as they dont belong
Date: Mon, 17 Nov 2008 08:31:30 -0600
References: <1226772154-6109-1-git-send-email-galak@kernel.crashing.org> <491F107E.4070702@redhat.com>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 15, 2008, at 12:10 PM, Steven Rostedt wrote:

> Kumar Gala wrote:
>> For some unknown reason at Steven Rostedt added in disabling of the  
>> SPE
>> instruction generation for e500 based PPC cores in commit
>> 6ec562328fda585be2d7f472cfac99d3b44d362a.
>>
>
> The unknown reason was that my PPC64 failed to compile without  
> it ;-) It was unknown because I forgot to mention that in the change  
> log (my bad).
>
> On Monday, I'll apply this patch and make sure that my PPC64 still  
> compiles.
>
> -- Steve

Thanks, if you can Ack the patch today if it works for you that would  
be great.

- k

>
>
>> We are removing it because:
>>
>> 1. It generates e500 kernels that don't work
>> 2. its not the correct set of flags to do this
>> 3. we handle this in the arch/powerpc/Makefile already
>> 4. its unknown in talking to Steven why he did this
>>
>> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
>> ---
>> kernel/Makefile |    4 +---
>> 1 files changed, 1 insertions(+), 3 deletions(-)
>

