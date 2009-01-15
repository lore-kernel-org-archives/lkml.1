Return-Path: <linux-kernel-owner+w=401wt.eu-S1762519AbZAONWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762519AbZAONWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 08:22:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755220AbZAONWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 08:22:22 -0500
Received: from ftp.linux-mips.org ([213.58.128.207]:51503 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705AbZAONWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 08:22:22 -0500
Date: Thu, 15 Jan 2009 13:22:14 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jan-Benedict Glaw <jbglaw@lug-owl.de>
cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>,
       Adam Osuchowski <adwol@zonk.pl>, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Is 386 processor still supported?
In-Reply-To: <20090115123614.GR11087@lug-owl.de>
Message-ID: <alpine.LFD.1.10.0901151309420.5737@ftp.linux-mips.org>
References: <20090108120338.6b8b4567@zonk.pl> <alpine.LRH.1.10.0901081359520.24105@twin.jikos.cz> <1231424025.11687.447.camel@twins> <alpine.LNX.1.10.0901081518070.5377@jikos.suse.cz> <1231424833.11687.452.camel@twins> <20090108150448.2393aeb0@lxorguk.ukuu.org.uk>
 <20090108151046.GK18120@elte.hu> <alpine.LFD.1.10.0901130047160.10547@ftp.linux-mips.org> <20090115123614.GR11087@lug-owl.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009, Jan-Benedict Glaw wrote:

>   * Debian's baseline libc is compiled to use LOCK and some other
>     newish instructions that are not available on a real i386 CPU.

 LOCK dates back to the 8086 -- it has to work with the i386.  What is not 
supported are the following i486 additions: CMPXCHG (amusingly enough 
early i486 steppings used a different opcode for this one; no idea if it 
is still possible to find such a CPU), XADD and BSWAP, the latter being 
fairly unimportant.

>   * There was a patch flying around to introduce a kernel-based
>     emulator for those instructions. However, this was (at that time)
>     neither included in Debian's kernel, nor in the upstream sources.

 UP emulation of CMPXCHG and XADD for userland should be rather trivial, 
so why not include it like with LL/SC for MIPS?

  Maciej
