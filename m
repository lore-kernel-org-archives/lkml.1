Return-Path: <linux-kernel-owner+w=401wt.eu-S964838AbXBYVOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964838AbXBYVOJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 16:14:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965058AbXBYVOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 16:14:09 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35153 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964838AbXBYVOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 16:14:08 -0500
Date: Sun, 25 Feb 2007 22:13:52 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Zwane Mwaikambo <zwane@infradead.org>, Ashok Raj <ashok.raj@intel.com>,
       Ingo Molnar <mingo@elte.hu>, "Lu, Yinghai" <yinghai.lu@amd.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 12/14] x86_64 irq: Add constants for the reserved IRQ vectors.
Message-ID: <20070225211352.GA2690@elf.ucw.cz>
References: <m1ejohung7.fsf_-_@ebiederm.dsl.xmission.com> <m17iu9unb6.fsf_-_@ebiederm.dsl.xmission.com> <m13b4xun1c.fsf_-_@ebiederm.dsl.xmission.com> <m1y7mpt8d2.fsf_-_@ebiederm.dsl.xmission.com> <m1tzxdt8au.fsf_-_@ebiederm.dsl.xmission.com> <m1ps81t87h.fsf_-_@ebiederm.dsl.xmission.com> <20070225104327.GF2045@elf.ucw.cz> <m1wt26pjxp.fsf@ebiederm.dsl.xmission.com> <20070225194817.GB1746@elf.ucw.cz> <m1irdqostc.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1irdqostc.fsf@ebiederm.dsl.xmission.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Pavel Machek <pavel@ucw.cz> writes:
> 
> > BUILD_BUG_ON(x > 15) ? ;-).
> 
> That might work.  Can you use that in a constant expression?
> Still it is a complexity for a  handful of lines.
> 
> I would prefer to go with something simple at this point.

I was thinking something like

#define IRQ(n) ({ BUILD_BUG_ON(n > 15); n; })

...but I did not really test it, so...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
