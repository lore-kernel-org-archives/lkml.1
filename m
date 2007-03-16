Return-Path: <linux-kernel-owner+w=401wt.eu-S1753418AbXCPF6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbXCPF6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 01:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932130AbXCPF6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 01:58:39 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:51443 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753418AbXCPF6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 01:58:39 -0400
Message-ID: <45FA320D.4010102@vmware.com>
Date: Thu, 15 Mar 2007 21:58:37 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jan Beulich <jbeulich@novell.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chris Wright <chrisw@sous-sol.org>, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: [RFC, PATCH] Fixup COMPAT_VDSO to work with CONFIG_PARAVIRT
References: <45FA054F.6020107@vmware.com> <45FA0D13.6080601@goop.org> <45FA16FE.7010805@vmware.com> <45FA26DA.7020109@goop.org>
In-Reply-To: <45FA26DA.7020109@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>   
>>>> +        } else if (strcmp(secstrings+sechdrs[i].sh_name,
>>>> ".dynamic") == 0) {
>>>> +            Elf32_Dyn *dyn = (void *)hdr + sechdrs[i].sh_offset;
>>>> +            int tag;
>>>> +            while ((tag = (++dyn)->d_tag) != DT_NULL)
>>>>       
>>>>         
>>> Um, no.
>>>   
>>>       
>> Walk based on size instead?
>>     
>
> No, I was just complaining about the embedded assignment, before dinner,
> so I was overly terse.
>   

My last embedded assignment was a robot microcontroller, and I dropped 
out of that class.  So I _need_ embedded assignments.

Zach
