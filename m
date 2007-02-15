Return-Path: <linux-kernel-owner+w=401wt.eu-S1161155AbXBOURN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161155AbXBOURN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 15:17:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161156AbXBOURM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 15:17:12 -0500
Received: from warden-p.diginsite.com ([208.29.163.248]:36869 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1161155AbXBOURM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 15:17:12 -0500
Date: Thu, 15 Feb 2007 12:01:22 -0800 (PST)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Roman Zippel <zippel@linux-m68k.org>
cc: David Howells <dhowells@redhat.com>, torvalds@osdl.org, akpm@osdl.org,
       herbert.xu@redhat.com, linux-kernel@vger.kernel.org, davej@redhat.com,
       arjan@infradead.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing 
In-Reply-To: <Pine.LNX.4.64.0702151901380.14458@scrub.home>
Message-ID: <Pine.LNX.4.63.0702151155330.9862@qynat.qvtvafvgr.pbz>
References: <Pine.LNX.4.64.0702151530260.14458@scrub.home> 
 <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com> 
 <32081.1171560770@redhat.com> <Pine.LNX.4.64.0702151901380.14458@scrub.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007, Roman Zippel wrote:

> On Thu, 15 Feb 2007, David Howells wrote:
>
>> It is possible to protect /dev/mem and /dev/kmem or make them unavailable and
>> it is possible to protect the kernel's memory whilst it is running (provided
>> you don't have nommu or broken hardware and you don't let userspace concoct any
>> DMA request it likes) which mostly closes those other vectors I mentioned.
>> This isn't something I intended to look at with this patch.  Those are separate
>> holes.
>
> Exactly and as long as there are these holes, these patches are only
> kernel bloat. The simple verification can also be done in userspace and
> module signing offers no real security.
> What real value do these patches provide, that can't be reached via other
> means? Who else than distributions would be interested in this? Pretty
> much any use you initially mentioned can be done in simpler ways, e.g.
> anyone afraid of modules simply disables module loading completely.

this issue, and these holes keep comeing up in discussions, why can't these 
holes be closed? I seem to remember seeing patches that would remove /dev/kmem 
being sent to the list, but they weren't accepted into the kernel (and I seem to 
remember people being against the concept of removeing them, not against 
techincal details of the patches. but this was many years ago)

at one point I remember hearing that X required raw /dev/kmem, but for servers 
you don't need/want X anyway, so this is a useful option even if X doesn't get 
fixed.

David Lang
