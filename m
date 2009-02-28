Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbZB1Hgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbZB1Hgy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 02:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbZB1Hgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 02:36:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbZB1Hgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 02:36:45 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       linux-mips@linux-mips.org, sparclinux@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/2] x86-64: seccomp: fix 32/64 syscall hole
In-Reply-To: Ingo Molnar's message of  Saturday, 28 February 2009 08:31:54 +0100 <20090228073154.GG9351@elte.hu>
References: <20090228030226.C0D34FC3DA@magilla.sf.frob.com>
	<20090228030413.5B915FC3DA@magilla.sf.frob.com>
	<alpine.LFD.2.00.0902271932520.3111@localhost.localdomain>
	<alpine.LFD.2.00.0902271948570.3111@localhost.localdomain>
	<20090228072554.CFEA6FC3DA@magilla.sf.frob.com>
	<20090228073154.GG9351@elte.hu>
Emacs: the prosecution rests its case.
Message-Id: <20090228073604.84F3EFC3DA@magilla.sf.frob.com>
Date: Fri, 27 Feb 2009 23:36:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> btw., shouldnt is_compat_task() expand to 0 in the 
> !CONFIG_COMPAT case? That way we could remove this #ifdef too. 
> (and move the first #ifdef inside the array initialization so 
> that we always have a mode1_syscalls_32[] array.)

I guess you mean define it in linux/compat.h then?
Go right ahead.  Whatever you want is fine by me.


Thanks,
Roland
