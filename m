Return-Path: <linux-kernel-owner+w=401wt.eu-S1762853AbYEFPHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762853AbYEFPHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 11:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757338AbYEFPHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 11:07:35 -0400
Received: from mail.gmx.net ([213.165.64.20]:54021 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754512AbYEFPHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 11:07:34 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX1+w7B9Xo4CwOGVq5H3oPj5bKlqKQMAR1x58tKixEv
	H8GFx8JdUGPCim
Date: Tue, 6 May 2008 17:07:30 +0200
From: Eric Sesterhenn <snakebyte@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederik Deweerdt <deweerdt@free.fr>, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Oops with strace_test
Message-ID: <20080506150730.GA6388@alice>
References: <20080430121202.GD18314@alice> <20080505100008.GA2354@alice> <20080505180053.GB5576@slug> <20080506121005.GJ32591@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080506121005.GJ32591@elte.hu>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.25 (x86_64)
X-Uptime: 17:07:00 up 1 day,  2:01,  2 users,  load average: 0.00, 0.05,
	0.07
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Frederik Deweerdt <deweerdt@free.fr> wrote:
> 
> > Hi Eric,
> > 
> > This appears to be caused by init_fpu() missing from the 
> > restore_sigcontext->restore_i387->restore_fpu_checking code path.
> > 
> > I believe that moving the init_fpu() call from math_state_restore to 
> > restore_fpu_checking should fix the problem?
> 
> thanks Eric and Frederik for tracking this down. Eric, does Frederik's 
> patch fix the problem for you?

didnt have a chance to test this yet, I'll be back home tomorrow and
test Frederiks patch.

Greetings, Eric
