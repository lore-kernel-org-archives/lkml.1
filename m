Return-Path: <linux-kernel-owner+w=401wt.eu-S1756817AbZETWqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbZETWqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 18:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755889AbZETWql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 18:46:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38643 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755716AbZETWql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 18:46:41 -0400
Date: Thu, 21 May 2009 00:52:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] xen /proc/mtrr implementation
Message-ID: <20090520225235.GJ8684@one.firstfloor.org>
References: <4A0DCC11.10307@goop.org> <m1my9ex818.fsf@fess.ebiederm.org> <4A0DFF78.6000501@goop.org> <20090515202250.0f1218ef@jbarnes-g45> <m1iqk1k708.fsf@fess.ebiederm.org> <4A10EAC4.9070701@goop.org> <20090518085902.GE10687@elte.hu> <4A11A3F8.1010202@goop.org> <87tz3gnq91.fsf@basil.nowhere.org> <4A143251.90208@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A143251.90208@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >Is this new interface only defined for swiotlb or MMIO mappings?
> >If yes did you check the drivers only actually set it on
> >swiotlb or MMIO (that seems dubious to me)?
> 
> Really?   Do we ever set unusual memory types on normal system memory?  

There were drivers at some point that set WC MTRRs on their
transfer rings, not mmio.

Maybe these all switched to PAT now, maybe not

It's hard to say because it could be also done from user space.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
