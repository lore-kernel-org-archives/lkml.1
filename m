Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbZCBM0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbZCBM0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 07:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbZCBM0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 07:26:30 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58814 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891AbZCBM03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 07:26:29 -0500
Message-ID: <49ABD05C.3010906@redhat.com>
Date: Mon, 02 Mar 2009 13:26:04 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] xen: core dom0 support
References: <1235786365-17744-1-git-send-email-jeremy@goop.org> <20090227212812.26d02f34.akpm@linux-foundation.org> <49A8DF28.4050301@goop.org> <20090228072055.GC9351@elte.hu> <49ABA633.2050903@redhat.com> <20090302120445.GA29015@elte.hu>
In-Reply-To: <20090302120445.GA29015@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Gerd Hoffmann <kraxel@redhat.com> wrote:
>> The current, out-of-tree xen kernel stuff is based on 2.6.18. 
>> [...]
> 
> Sure, but what i'm pointing out is the following aspect of 
> communication:
> 
>>>> [...] At the moment its all running on massive out-of-tree 
>>>> patches, which doesn't make anyone happy.  It's best that it 
>>>> be in the mainline kernel.  You know, like we argue for 
>>>> everything else.
> 
> Comparing it to a 2.6.18 base is simply misleading when it comes 
> to upstreaming something. Enterprise distros will rebase, and 
> their out-of-tree pile of patches will shrink.

I think Jeremy refers to the 2.6.18 kernel though.  And IMHO it isn't
misleading as this is the only option for a dom0 kernel.  Well, was
until very recently, now you can also run the latest pv_ops bits with
dom0 support.  That is still very young code though and I wouldn't use
that (yet) for production systems.  Works fine on my development box though.

The bits needed for pv_ops based dom0 support in arch/x86 is small
compared to what is already there for domU support.

cheers,
  Gerd
