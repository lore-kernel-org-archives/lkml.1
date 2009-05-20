Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbZETWt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbZETWt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 18:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755283AbZETWtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 18:49:47 -0400
Received: from claw.goop.org ([74.207.240.146]:36421 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbZETWtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 18:49:46 -0400
Message-ID: <4A1488ED.6080604@goop.org>
Date: Wed, 20 May 2009 15:49:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] xen /proc/mtrr implementation
References: <4A0DCC11.10307@goop.org> <m1my9ex818.fsf@fess.ebiederm.org> <4A0DFF78.6000501@goop.org> <20090515202250.0f1218ef@jbarnes-g45> <m1iqk1k708.fsf@fess.ebiederm.org> <4A10EAC4.9070701@goop.org> <20090518085902.GE10687@elte.hu> <4A11A3F8.1010202@goop.org> <87tz3gnq91.fsf@basil.nowhere.org> <4A143251.90208@goop.org> <20090520225235.GJ8684@one.firstfloor.org>
In-Reply-To: <20090520225235.GJ8684@one.firstfloor.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> There were drivers at some point that set WC MTRRs on their
> transfer rings, not mmio.
>   

To avoid cache pollution effects?

> Maybe these all switched to PAT now, maybe not
>
> It's hard to say because it could be also done from user space.
>   

How does userspace do the virtual to physical mapping?  If the driver 
can't also deal with the extra conversion from physical to machine under 
Xen, then it won't have much success either way.

    J
