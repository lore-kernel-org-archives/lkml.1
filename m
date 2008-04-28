Return-Path: <linux-kernel-owner+w=401wt.eu-S936780AbYD1TA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936780AbYD1TA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966176AbYD1TAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:00:39 -0400
Received: from mail.tmr.com ([64.65.253.246]:51140 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935059AbYD1TAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:00:38 -0400
Message-ID: <4816205D.7000109@tmr.com>
Date: Mon, 28 Apr 2008 15:07:09 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Tomasz Chmielewski <mangoo@wpkg.org>
CC: LKML <linux-kernel@vger.kernel.org>, jbarnold@MIT.EDU,
       francois.cami@free.fr, Andi Kleen <andi@firstfloor.org>,
       mail@earthworm.de
Subject: Re: A system for rebootless kernel security updates
References: <481098A4.50107@wpkg.org>
In-Reply-To: <481098A4.50107@wpkg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Chmielewski wrote:
> Jeff Arnold wrote:
> 
>> I've put together an automatic system for applying kernel security 
>> patches to the Linux kernel without rebooting it, and I wanted to 
>> share this system with the community in case others find it useful or 
>> interesting.
> 
> Hmm, the idea seem to be patented by Microsoft, i.e. this patent from 
> December 2002:
> 
> http://www.google.com/patents?id=cVyWAAAAEBAJ&dq=hotpatching
> 
> (and other patents by Microsoft if you search for "hotpatching").
> 
> 
> And those patent descriptions, by the way, remind the way kexec works 
> ("A software module is hotpatched by loading a patch into memory and 
> modifying an instruction in the original module to jump to the patch"), 
> which was released much earlier... In essence, they patented kexec ;)
> 
I think you will find prior art all the way back to the PDP-8 (or 11) 
and if memory serves DTSS, which was in the 1960's. I think MULTICS 
allowed that as well, by patching the library dispatch table (sort of 
like TLB) to map a virtual address of the entry point to a new location.

All of which doesn't matter, of course, because no one has the money to 
challenge MSFT, and it would be in court until the heat death of the 
universe anyway.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
