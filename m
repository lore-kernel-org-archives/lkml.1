Return-Path: <linux-kernel-owner+w=401wt.eu-S1754373AbZB1J5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbZB1J5b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 04:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbZB1J5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 04:57:22 -0500
Received: from gw.goop.org ([64.81.55.164]:37395 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbZB1J5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 04:57:22 -0500
Message-ID: <49A90A7E.10101@goop.org>
Date: Sat, 28 Feb 2009 01:57:18 -0800
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
References: <1235786365-17744-1-git-send-email-jeremy@goop.org> <20090227212812.26d02f34.akpm@linux-foundation.org> <49A8DF28.4050301@goop.org> <20090228072055.GC9351@elte.hu> <49A8F04D.4090409@goop.org> <20090228083621.GC11425@elte.hu>
In-Reply-To: <20090228083621.GC11425@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> This means that the "massive out-of-tree patches which doesn't 
> make anyone happy" argument above is really ... a hiperbole and 
> should be replaced with: "small, unintrusive out-of-tree patch"?

Well at the moment we're in the "doesn't make anybody happy" state.  The 
dom0 changes I have are, I'll admit, non-trivial.  I don't think they're 
unreasonable or particularly intrusive, but they are large enough to be 
awkward to maintain out of tree.  What I'm looking to achieve now is to 
get enough into the kernel so that the remaining patches are a "small 
unintrusive out-of-tree patch" (but ultimately I'd like to get 
everything in).

But I think that's sort of beside the point.  Its not like we're talking 
about something extremely obscure here; these changes do serve a large 
existing user-base.  The (often repeated) kernel policy is "merge it".  
I'm happy to talk about the specifics of how all this stuff can be made 
to fit together - and whether the current approach is OK or if something 
else would be better, but ultimately I think this functionality does 
belong in mainline.

    J
