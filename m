Return-Path: <linux-kernel-owner+w=401wt.eu-S1764789AbYEGVqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764789AbYEGVqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 17:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755030AbYEGVqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 17:46:33 -0400
Received: from mail.gmx.net ([213.165.64.20]:36695 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754865AbYEGVqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 17:46:31 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX1/iURJUWPjiacvCg8PA2J4KMNYGj8tQL28MlqyoeL
	yjqmiVThfh2rM0
Date: Wed, 7 May 2008 23:46:28 +0200
From: Eric Sesterhenn <snakebyte@gmx.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Frederik Deweerdt <deweerdt@free.fr>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Oops with strace_test
Message-ID: <20080507214628.GA4156@alice>
References: <20080430121202.GD18314@alice> <20080505100008.GA2354@alice> <20080505180053.GB5576@slug> <20080506121005.GJ32591@elte.hu> <20080507103615.GC2340@alice> <alpine.LFD.1.10.0805071534580.3318@apollo.tec.linutronix.de> <20080507172032.GB3348@alice> <alpine.LFD.1.10.0805071924550.3318@apollo.tec.linutronix.de> <20080507190952.GA11931@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080507190952.GA11931@linux-os.sc.intel.com>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.25 (x86_64)
X-Uptime: 23:44:50 up  9:59,  5 users,  load average: 0.12, 0.12, 0.09
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Suresh Siddha (suresh.b.siddha@intel.com) wrote:
> On Wed, May 07, 2008 at 07:26:20PM +0200, Thomas Gleixner wrote:
> > 
> > Ok, we decoded the problem in meantime. Suresh will send a patch soon.
> 
> Appended patch should fix it. Eric, can you please check if it fixes the issue?
> I have to fix the math-emu aswell. But I will send a different patch for it.

running the test for 20 minutes now, no oops seen so far, seems to be
the right fix. 

Thanks, Eric
