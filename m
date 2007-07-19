Return-Path: <linux-kernel-owner+w=401wt.eu-S1764634AbXGSM5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764634AbXGSM5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 08:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936187AbXGSM5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 08:57:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:45898 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936158AbXGSM5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 08:57:21 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Stable Team <stable@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] X86_64: hpet tsc calibration fix broken smi detection logic
References: <1184402499.12353.340.camel@chaos>
	<20070718195932.ea72e6f0.akpm@linux-foundation.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 19 Jul 2007 15:52:21 +0200
In-Reply-To: <20070718195932.ea72e6f0.akpm@linux-foundation.org>
Message-ID: <p73sl7kwley.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
> 
> So I queued this, and then another patch to revert it so that the
> x86_64-clockevents conversion would apply.  But I was unable to locate the
> corresponding bug in the post-x86_64-clockevents tree.  Did it get fixed by
> other means in there?

Yes, the code gets merged with i386 there

-Andi
