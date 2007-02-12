Return-Path: <linux-kernel-owner+w=401wt.eu-S964804AbXBLJQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964804AbXBLJQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 04:16:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964810AbXBLJQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 04:16:46 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:52247 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964808AbXBLJQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 04:16:45 -0500
Message-ID: <45D0307C.1040302@vmware.com>
Date: Mon, 12 Feb 2007 01:16:44 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.osdl.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 5/7] cleanup: Rename cpu_gdt_descr and remove extern	declaration
 from smpboot.c
References: <1171251120.10409.2.camel@localhost.localdomain>	 <1171251185.10409.4.camel@localhost.localdomain>	 <1171251258.10409.7.camel@localhost.localdomain>	 <1171251335.10409.10.camel@localhost.localdomain> <1171251406.10409.13.camel@localhost.localdomain>
In-Reply-To: <1171251406.10409.13.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> When I implemented the DECLARE_PER_CPU(var) macros, I was careful that
> people couldn't use "var" in a non-percpu context, by prepending
> percpu__.  I never considered that this would allow them to overload
> the same name for a per-cpu and a non-percpu variable.
>
> It is only one of many horrors in the i386 boot code, but let's rename
> the non-perpcu cpu_gdt_descr to early_gdt_descr (not boot_gdt_descr,
> that's something else...)
>   

Finally, someone not just noticed, but fixed it!  Thank you Rusty.  Was 
on my todo list, but never bubbled up.

Acked-by: Zachary Amsden <zach@vmware.com>
