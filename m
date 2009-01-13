Return-Path: <linux-kernel-owner+w=401wt.eu-S1758368AbZAMM7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368AbZAMM7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 07:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058AbZAMM7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 07:59:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52675 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197AbZAMM7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 07:59:43 -0500
Date: Tue, 13 Jan 2009 13:59:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Subject: Re: [PATCH -tip] x86: headers - include linux/types.h instead of
	asm/types.h
Message-ID: <20090113125928.GA31147@elte.hu>
References: <20090113120905.GB7682@localhost> <20090113125705.GC7682@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113125705.GC7682@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> [Cyrill Gorcunov - Tue, Jan 13, 2009 at 03:09:05PM +0300]
> | Impact: cleanup
> | 
> | 'make headers_check' warns that linux/types.h is
> | preferred over asm/types.h. So be it.
> | 
> | Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> | CC: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> | CC: Sam Ravnborg <sam@ravnborg.org>
> | CC: Harvey Harrison <harvey.harrison@gmail.com>
> | ---
> | 
> |  arch/x86/include/asm/e820.h       |    2 ++
> |  arch/x86/include/asm/kvm.h        |    2 +-
> |  arch/x86/include/asm/mce.h        |    2 +-
> |  arch/x86/include/asm/mtrr.h       |    1 +
> |  arch/x86/include/asm/ptrace-abi.h |    2 +-
> |  arch/x86/include/asm/sigcontext.h |    2 +-
> |  arch/x86/include/asm/swab.h       |    2 +-
> |  7 files changed, 8 insertions(+), 5 deletions(-)
> |
> ...
> 
> well... on the other hand I'm not sure if it's really
> a good idea to include linux/types.h where we need only
> __u[8,16] and so on definitions.

Well, linux/types.h is supposed to be a 'lightweight', 'core data types 
only' kind of header file, so including it is not wrong per se.

Sam, is there some other preferred way perhaps to resolve these?

	Ingo
