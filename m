Return-Path: <linux-kernel-owner+w=401wt.eu-S1752284AbXCEOMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbXCEOMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 09:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933017AbXCEOMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 09:12:53 -0500
Received: from il.qumranet.com ([82.166.9.18]:39713 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284AbXCEOMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 09:12:53 -0500
Message-ID: <45EC24CA.1020707@qumranet.com>
Date: Mon, 05 Mar 2007 16:10:18 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch] paravirt: VDSO page is essential
References: <20070305120631.GA14105@elte.hu> <45EC0EB7.7080300@qumranet.com> <20070305142820.GD22829@bingen.suse.de> <20070305134854.GA31542@elte.hu> <20070305145847.GH22829@bingen.suse.de> <20070305135918.GA32380@elte.hu>
In-Reply-To: <20070305135918.GA32380@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Andi Kleen <ak@suse.de> wrote:
>
>   
>> I think we would need to have a paravirt ops callback to decide this 
>> first. But it doesn't look critical to me anyways.
>>     
>
> well, it's critical to me in two ways: 1) to make the i386 paravirt code 
> clean 2) to have a proper VDSO for a KVM paravirtual guest. The original 
> change is also bad because it changes how a Linux guest behaves: it 
> turns off the vdso by default, and disables the compat VDSO. I.e. it's a 
> bad performance step backwards if CONFIG_PARAVIRT is enabled (uses int 
> $0x80 instead of sysenter), which hurts only KVM and basically none of 
> the other hypervisors. It also muddifies the VDSO picture wrt. 
> virtualization.
>
>   

kvm paravirt is only used by developers at this time.  I don't have a 
problem with solving this in the 2.6.22 timeframe.

-- 
error compiling committee.c: too many arguments to function

