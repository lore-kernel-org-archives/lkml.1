Return-Path: <linux-kernel-owner+w=401wt.eu-S1766996AbXDSVXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766996AbXDSVXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 17:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766995AbXDSVXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 17:23:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766996AbXDSVXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 17:23:06 -0400
Message-ID: <4627DDAD.4070805@redhat.com>
Date: Thu, 19 Apr 2007 17:22:53 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andi Kleen <ak@suse.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>, Chris Wright <chrisw@sous-sol.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 10/28] i386: map enough initial memory to create lowmem
 mappings
References: <20070414204154.871250608@goop.org> <200704192250.52633.ak@suse.de> <4627D756.5020405@zytor.com> <200704192304.01053.ak@suse.de> <4627DB0C.2010804@zytor.com>
In-Reply-To: <4627DB0C.2010804@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Andi Kleen wrote:
>> On Thursday 19 April 2007 22:55:50 H. Peter Anvin wrote:
>>> Andi Kleen wrote:
>>>>> Is some version of this going in for 2.6.21, or is it not a real
>>>>> problem?
>>>> When it's only seen with Xen it's not a real problem right now.
>>> It's not just seen only with Xen, though.  It will affect all kernels
>>> in a particular range of sizes, and we have ordinary kernels covering
>>> that range (in fact, Xen hardly affects size in that way.)
>>
>> Then we would have seen reports surely?
> 
> The critical size window is relatively small, though.  The size of the
> uncompressed kernel mod 4 MB must be above 3.75 MB or so.  If you have
> less than 1 GB RAM, the window is even smaller.  This is strictly
> configuration-dependent, and has nothing to do with Xen.  It just so
> happened that the first people to detect and diagnose it (as opposed to
> just "it doesn't boot") were Xen people.

I never saw a description of the symptoms of encountering this bug.
Does it just hang, or what?

