Return-Path: <linux-kernel-owner+w=401wt.eu-S933901AbXHVXMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933901AbXHVXMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 19:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763246AbXHVXMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 19:12:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763120AbXHVXMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 19:12:45 -0400
Date: Wed, 22 Aug 2007 19:09:51 -0400
From: Dave Jones <davej@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Announce] Unified x86 architecture, arch/x86 - V2
Message-ID: <20070822230951.GI17546@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	LKML <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
	Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
	Arjan van de Ven <arjan@infradead.org>,
	Chris Wright <chrisw@sous-sol.org>,
	Steven Rostedt <rostedt@goodmis.org>
References: <1187819782.3316.8.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187819782.3316.8.camel@chaos>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 11:56:22PM +0200, Thomas Gleixner wrote:
 > We are pleased to announce v2 of the unified arch/x86 project we are 
 > working on.
 > 
 > To recap: the core idea behind our project is simple to describe: we 
 > introduce a new arch/x86/ and include/asm-x86/ file hierarchy that 
 > includes all the existing 32-bit and 64-bit x86 code and allows the 
 > building of either a 32-bit (i386) kernel or a 64-bit (x86_64) kernel. 
 > No code is lost and almost no code is modified. We want the window 
 > for regressions and tree incompatibilities to be zero. (The full initial 
 > announcement can be found at http://lkml.org/lkml/2007/7/20/447)
 > 
 > The main technical request for improvement we received was the lack of a 
 > patch-series, and this v2 release does that, in form of a 600+ commits 
 > git tree:
 > 
 >  git://git.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-x86.git

Nice work.  cpufreq bits look sane from a quick eyeball.

	Dave

-- 
http://www.codemonkey.org.uk
