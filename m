Return-Path: <linux-kernel-owner+w=401wt.eu-S1757105AbYDRAsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105AbYDRAsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 20:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbYDRAsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 20:48:05 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:62903 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756029AbYDRAsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 20:48:04 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEANuMB0hMROPA/2dsb2JhbACBYKsz
Date: Thu, 17 Apr 2008 20:48:00 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       akpm@osdl.org, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>
Subject: Re: [RFC PATCH] x86 NMI-safe INT3 and Page Fault (v2)
Message-ID: <20080418004800.GA7758@Krystal>
References: <20080414230344.GA16061@Krystal> <20080414230530.GB16061@Krystal> <20080416130605.GG6304@elte.hu> <20080416151054.GA32456@elte.hu> <48062343.50606@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48062343.50606@goop.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 20:47:00 up 48 days, 20:57,  5 users,  load average: 0.16, 0.19,
	0.13
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> Ingo Molnar wrote:
>> * Ingo Molnar <mingo@elte.hu> wrote:
>>
>>   
>>> thanks Mathieu, i've picked this up into x86.git for more testing.
>>>     
>>
>> ... but had to drop it due to missing PARAVIRT support which broke the 
>> build. I guess on paravirt we could just initially define 
>> INTERRUPT_RETURN_NMI_SAFE to iret, etc.?
>
> I have not yet implemented Xen's support for paravirtual NMI, so there's no 
> scope for breaking anything from my perspective.  When I get around to NMI, 
> I'll work around whatever's there.  I don't know if lguest or VMI has any 
> guest NMI support.
>
>    J
>

I wonder if we could simply paravirtualize the popf instruction, which
seems to be the only one requiring to run in ring 0.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
