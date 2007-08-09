Return-Path: <linux-kernel-owner+w=401wt.eu-S1765933AbXHIU6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765933AbXHIU6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 16:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756677AbXHIU54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 16:57:56 -0400
Received: from il.qumranet.com ([82.166.9.18]:43390 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755919AbXHIU5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 16:57:55 -0400
Message-ID: <46BB7FCC.4040509@qumranet.com>
Date: Thu, 09 Aug 2007 23:57:48 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Gabriel Barazer <gabriel@oxeva.fr>, Andi Kleen <ak@suse.de>,
       Jim Mattson <jmattson@vmware.com>, linux-kernel@vger.kernel.org,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: 2.6.22 x86_64 : kernel initial decompression hangs on vmware
References: <46A7E606.4030001@oxeva.fr> <46B4A7E4.4030907@vmware.com>
In-Reply-To: <46B4A7E4.4030907@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
>
> Since I was just involved in the boot decompressor for another bug, I 
> took a look at this.  2.6.22 switches it to be 64-bit code.  VT is 
> very picky about what state it can run in.  Not using VT on Intel 
> 64-bit hardware cripples performance, running at far below normal 
> speed, and taking minutes to decompress the kernel, which is nearly 
> instantaneous otherwise.
>
> To get back into VT in this case, not only do we need to load FS and 
> GS, we also need to setup an initial LDT and task.  Can you try the 
> attached patch and see that it does the right thing?
>
> I've also cc'd the KVM developers, as the same problem will affect 
> them, and hopefully the same patch will fix it.
>

We haven't seen any issue with the 2.6.22 boot decompressor.  Which of 
the four (fs, gs, ldt, or tr) were proving problematic and why?


