Return-Path: <linux-kernel-owner+w=401wt.eu-S1030664AbXC2UJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030664AbXC2UJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 16:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030669AbXC2UJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 16:09:29 -0400
Received: from ns2.suse.de ([195.135.220.15]:60116 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030656AbXC2UJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 16:09:28 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>, linux-ide@vger.kernel.org,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, gregkh@suse.de,
       linux-pm@lists.osdl.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, linux-acpi@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Thomas Gleixner <tglx@linutronix.de>, jgarzik@pobox.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] Add suspend/resume for HPET
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	<460BBD1B.4040308@ru.mvista.com>
	<200703291531.18253.maximlevitsky@gmail.com>
	<200703291546.48996.maximlevitsky@gmail.com>
	<Pine.LNX.4.64.0703290949060.6730@woody.linux-foundation.org>
	<20070329175117.GA5521@elte.hu>
From: Andi Kleen <andi@firstfloor.org>
Date: 29 Mar 2007 22:46:46 +0200
In-Reply-To: <20070329175117.GA5521@elte.hu>
Message-ID: <p734po33hhl.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
> 
> there's no fundamental reason. x86_64 COW-ed hpet_timer.c and 
> time_hpet.c years ago and drifted off into different areas.

Not quite -- x86-64 did HPET long before i386; the only stuff cowed
was the character driver support code. But the core HPET code
was always totally different code streams. We never did the complicated 
pluggable clock code i386 did though -- i never quite saw the point of that
because there aren't that many timers there.
Of course it is already obsolete with clocksources now.

-Andi
