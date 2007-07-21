Return-Path: <linux-kernel-owner+w=401wt.eu-S935197AbXGUI3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935197AbXGUI3x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 04:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935491AbXGUI2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 04:28:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37399 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760971AbXGUI2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 04:28:39 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
Date: Sat, 21 Jul 2007 10:28:32 +0200
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Steven Rostedt <rostedt@goodmis.org>
References: <1184970779.4012.38.camel@chaos> <200707210737.59552.ak@suse.de> <1185005750.4012.100.camel@chaos>
In-Reply-To: <1185005750.4012.100.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707211028.32465.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 July 2007 10:15:50 Thomas Gleixner wrote:

> 
> The script detected 15 identical files with a simple cmp.

You mean 


arch/i386/boot/.gitignore
arch/i386/boot/tools/.gitignore
arch/i386/oprofile/Kconfig
include/asm-i386/poll.h
include/asm-i386/emergency-restart.h
include/asm-i386/spinlock_types.h
include/asm-i386/vga.h
include/asm-i386/msidef.h
include/asm-i386/hypertransport.h
include/asm-i386/ioctl.h
include/asm-i386/fcntl.h

? 

[of which several just #include <asm-generic/foo.h] ? 

I suppose msidef.h and hypertransport.h should be shared agreed; 
for the others it is not obvious. spinlock_types will likely fork soon;
it used to be different in the past already and will be again.

-Andi

