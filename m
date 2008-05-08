Return-Path: <linux-kernel-owner+w=401wt.eu-S1761848AbYEHS3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761848AbYEHS3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 14:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755045AbYEHS3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 14:29:09 -0400
Received: from mail.gmx.net ([213.165.64.20]:46610 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754423AbYEHS3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 14:29:06 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX19fTLYRDzVf9MEaqcar6EqgPG3zEavqIbRtRSYY5r
	/Q5ZEoxRHjc+l7
Date: Thu, 8 May 2008 20:29:03 +0200
From: Eric Sesterhenn <snakebyte@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Frederik Deweerdt <deweerdt@free.fr>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Oops with strace_test
Message-ID: <20080508182903.GD2323@alice>
References: <20080430121202.GD18314@alice> <20080505100008.GA2354@alice> <20080505180053.GB5576@slug> <20080506121005.GJ32591@elte.hu> <20080507103615.GC2340@alice> <alpine.LFD.1.10.0805071534580.3318@apollo.tec.linutronix.de> <20080507172032.GB3348@alice> <alpine.LFD.1.10.0805071924550.3318@apollo.tec.linutronix.de> <20080507190952.GA11931@linux-os.sc.intel.com> <alpine.LFD.1.10.0805081700570.3318@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805081700570.3318@apollo.tec.linutronix.de>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.25 (x86_64)
X-Uptime: 20:27:52 up 27 min,  1 user,  load average: 0.47, 0.54, 0.50
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner (tglx@linutronix.de) wrote:
> On Wed, 7 May 2008, Suresh Siddha wrote:
> > On Wed, May 07, 2008 at 07:26:20PM +0200, Thomas Gleixner wrote:
> > > 
> > > Ok, we decoded the problem in meantime. Suresh will send a patch soon.
> > 
> > Appended patch should fix it. Eric, can you please check if it fixes the issue?
> > I have to fix the math-emu aswell. But I will send a different patch for it.
> 
> Suresh,
> 
> looks good. Applied to x86.git. Waiting for Erics confirmation.

i have been running the test now for ~4 hours, did reboot inbetween
twice and the oops didnt happen again, usually it occured in less
than 5 minutes, would say the patch fixed it.

Thanks, Eric

