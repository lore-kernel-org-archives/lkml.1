Return-Path: <linux-kernel-owner+w=401wt.eu-S1760132AbXHVMcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760132AbXHVMcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 08:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758187AbXHVMc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 08:32:27 -0400
Received: from il.qumranet.com ([82.166.9.18]:57476 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757772AbXHVMc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 08:32:26 -0400
Message-ID: <46CC2CE7.5000105@qumranet.com>
Date: Wed, 22 Aug 2007 15:32:39 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Rusty Russell <rusty@rustcorp.com.au>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: [PATCH] Add I/O hypercalls for i386 paravirt
References: <46CBC842.4070100@vmware.com> <46CBCADF.2070400@qumranet.com> <1187763956.6174.48.camel@localhost.localdomain> <20070822103545.GG2642@bingen.suse.de> <46CC0719.2080103@qumranet.com> <20070822110810.GO32640@bingen.suse.de> <46CC0EAF.3000805@qumranet.com> <20070822112352.GQ32640@bingen.suse.de> <46CC2766.7020602@qumranet.com> <20070822131547.GS32640@bingen.suse.de>
In-Reply-To: <20070822131547.GS32640@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Ah.  But that's mostly modules, so real in-core changes should be very 
>>     
>
> Yes that's the big difference. Near all paravirt ops are concentrated
> on the core kernel, but this one affects lots of people.
>
> And why "but"? -- modules are as important as the core kernel. They're
> not second citizens.
>   

It's not being second class; simply few modules are loaded at runtime, 
so most of the code impact is on disk.  The in-code impact is small.  If 
paravirt i/o insns are worthwhile, I don't think code size is an issue.

-- 
error compiling committee.c: too many arguments to function

