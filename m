Return-Path: <linux-kernel-owner+w=401wt.eu-S1761186AbZEHTS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761186AbZEHTS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 15:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756649AbZEHTSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 15:18:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59077 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbZEHTSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 15:18:46 -0400
To: =?iso-8859-1?Q?Markus_Gutschke_=28=DC=D2=D0=29?= 
	<markus@google.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       linux-mips@linux-mips.org, sparclinux@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/2] x86-64: seccomp: fix 32/64 syscall hole
From: Andi Kleen <andi@firstfloor.org>
References: <20090228030226.C0D34FC3DA@magilla.sf.frob.com>
	<20090228030413.5B915FC3DA@magilla.sf.frob.com>
	<alpine.LFD.2.00.0902271932520.3111@localhost.localdomain>
	<alpine.LFD.2.00.0902271948570.3111@localhost.localdomain>
	<20090228072554.CFEA6FC3DA@magilla.sf.frob.com>
	<alpine.LFD.2.00.0902280916470.3111@localhost.localdomain>
	<904b25810905061146ged374f2se0afd24e9e3c1f06@mail.gmail.com>
	<20090506212913.GC4861@elte.hu>
	<904b25810905061446m73c42040nfff47c9b8950bcfa@mail.gmail.com>
	<20090506215450.GA9537@elte.hu>
	<904b25810905061508n6d9cb8dbg71de5b1e0332ede7@mail.gmail.com>
Date: Fri, 08 May 2009 21:18:44 +0200
In-Reply-To: <904b25810905061508n6d9cb8dbg71de5b1e0332ede7@mail.gmail.com> (Markus Gutschke's message of "Wed, 6 May 2009 15:08:40 -0700")
Message-ID: <878wl7o12j.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Markus Gutschke (мва)" <markus@google.com> writes:
>
> There are a large number of system calls that "normal" C/C++ code uses
> quite frequently, and that are not security sensitive. A typical
> example would be gettimeofday().

At least on x86-64 gettimeofday() (and time(2)) work inside seccomp because 
they're vsyscalls that run in ring 3 only.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
