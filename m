Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbZB1IFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbZB1IFp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 03:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbZB1IFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 03:05:37 -0500
Received: from gw.goop.org ([64.81.55.164]:59131 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbZB1IFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 03:05:36 -0500
Message-ID: <49A8F04D.4090409@goop.org>
Date: Sat, 28 Feb 2009 00:05:33 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] xen: core dom0 support
References: <1235786365-17744-1-git-send-email-jeremy@goop.org> <20090227212812.26d02f34.akpm@linux-foundation.org> <49A8DF28.4050301@goop.org> <20090228072055.GC9351@elte.hu>
In-Reply-To: <20090228072055.GC9351@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Hm, how can the same code that you call "massive out-of-tree 
> patches which doesn't make anyone happy" in an out of tree 
> context suddenly become non-intrusive "minor amount of extra 
> stuff" in an upstream context?
>
> I wish the upstream kernel was able to do such magic, but i'm 
> afraid it is not.

No, but I am ;)  The current out of tree Xen patches are very intrusive 
because there hasn't been much incentive to reduce their impact.  I've 
going through it all and very carefully rewriting it 1) be cleaner, 2) 
enable/disable itself at runtime, 3) have clean interfaces and 
interactions with the rest of the kernel, and 4) address any concerns 
that others have.  In other words, make Xen a first-class kernel citizen.

Most of the intrusive stuff has already been merged (and merged for some 
time now), but without dom0 support its only half done; as it stands 
people are using mainline Linux for their domUs, but are still limited 
to patched up (old) kernels for dom0.  This is a real problem because 
all the drivers for interesting new devices are in the new kernels, so 
there's an additional burden of backporting device support into old kernels.

    J
