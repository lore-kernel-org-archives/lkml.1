Return-Path: <linux-kernel-owner+w=401wt.eu-S1761173AbYHUVVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761173AbYHUVVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 17:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759355AbYHUVVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 17:21:24 -0400
Received: from gw.goop.org ([64.81.55.164]:42547 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756563AbYHUVVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 17:21:23 -0400
Message-ID: <48ADDC4B.7020407@goop.org>
Date: Thu, 21 Aug 2008 14:21:15 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, jmerkey@wolfmountaingroup.com,
       Stefan Richter <stefanr@s5r6.in-berlin.de>, paulmck@linux.vnet.ibm.com,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: Re: [ANNOUNCE] mdb: Merkey's Linux Kernel Debugger  2.6.27-rc4 released
References: <200808210250.m7L2obNX028353@wolfmountaingroup.com> <48AD5A21.7020801@s5r6.in-berlin.de> <43593.166.70.238.46.1219321595.squirrel@webmail.wolfmountaingroup.com> <200808212337.38626.nickpiggin@yahoo.com.au> <48ADD8DE.3010209@goop.org> <alpine.LFD.1.10.0808211415410.3487@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808211415410.3487@nehalem.linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Thu, 21 Aug 2008, Jeremy Fitzhardinge wrote:
>   
>> "asm volatile" also has no effect on the ordering of the asm with 
>> respect to other code; you must use constraints to do that.
>>     
>
> Well, the gcc docs at _used_ to say that volatile asms are not moved 
> around "significantly". They've removed that.

Yep, they seem to do that kind of thing specifically to annoy you.  But
it does mean we can't rely on it at all any more.

    J

