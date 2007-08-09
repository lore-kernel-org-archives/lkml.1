Return-Path: <linux-kernel-owner+w=401wt.eu-S965306AbXHIQbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965306AbXHIQbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 12:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761992AbXHIQbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 12:31:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:38968 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508AbXHIQa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 12:30:59 -0400
In-Reply-To: <46B89C10.7090507@genesi-usa.com>
References: <200708020440.l724edCT290676@shell01.TheWorld.com> <46B79562.9020202@genesi-usa.com> <f4545a576abeddf00f076a0cae9e3fdd@kernel.crashing.org> <46B89C10.7090507@genesi-usa.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <909c5e405e5cd26bca3aff13fe55adbc@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@ozlabs.org, Alan Curry <pacman@TheWorld.com>,
       linux-kernel@vger.kernel.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH] powerpc: Pegasos keyboard detection
Date: Thu, 9 Aug 2007 18:30:35 +0200
To: Matt Sealey <matt@genesi-usa.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> That's hardly the only reason.  But yeah, that's one way to
>> implement the workaround, but _we_ (the Linux community) cannot
>> do it like that (easily) for all users.
>
> But you're the guy who told us our firmware sucks and we should fix our
> firmware

Yes, and?  You _should_ fix your firmware, it is buggy after all.
Esp. back then as it wasn't shipping yet.

> rather than clutter Linux with too many fixups.

Also, putting fixups in the wrapper is a wholly different thing from
putting fixups deep inside the kernel code proper.

> Linux is already a bad enough moving target, and none of these fixes 
> help
> other operating systems or developers, if we only patch Linux,

But that's not Linux' concern.  You might care, we don't.  Is
this so hard to understand?

> 1) the reports as we had when Efika was released and continually levied
> against Pegasos firmware, that the firmware is broken and must be fixed
> to comply, and no fixes will be considered because "bplan sucks and 
> must
> fix it"
>
> 2) As long as the patches are 2 lines big, you will allow them in, 
> because
> it is too much for a user to update firmware or run a script to boot?

Our only two concerns are what is best on technical grounds, and what
is best for our users.

> Would you guys rather we shipped a boot script that ran the OS, fixed
> all these issues in-place in-firmware, so Linux did not have to have 
> these
> workarounds,

Sure, if you can do that, that would be great.


Segher

