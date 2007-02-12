Return-Path: <linux-kernel-owner+w=401wt.eu-S965223AbXBLWhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965223AbXBLWhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 17:37:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965427AbXBLWhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 17:37:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965223AbXBLWhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 17:37:08 -0500
Message-ID: <45D0EC39.8030608@redhat.com>
Date: Mon, 12 Feb 2007 17:37:45 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86 for review III] [17/29] x86: Add new CPUID bits for
 AMD Family 10 CPUs in /proc/cpuinfo
References: <20070212551.664370000@suse.de> <20070212165137.AD85913E1B@wotan.suse.de> <45D0E60F.2090506@redhat.com> <200702122323.53364.andi@firstfloor.org>
In-Reply-To: <200702122323.53364.andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:

>> Since we seem to have become the place where all these are collected,
>> shouldn't we document what they mean?
> 
> This is not a data sheet and the CPU vendors have fine tech writers
> working on this already.
> 
> Also I don't really want to encourage people to hack this without
> at least taking a basic look at the documentation first.
> 
>> I've got some this machine that 
>> I'd like to know more about:
>>
>> dts ss ds_cpl est tm2 ssse3 xtpr
> 
> All documented in Intel documentation. But it's all relatively boring stuff
> 
> dts = debug trace store
> ss = self snoop
> ds_cpl = cpl qualified debug store
> est = enhanced speedstep
> tm2 = thermal monitor 2
> ssse3 = more sse3 instructions
> xtpr = tpr register chipset update control msr
> 

That's exactly what I was asking for.  Our abbreviations are too cryptic
to let someone go look up the meanings without a lot of trouble.

A one-liner for each in the comments would be just enough.

