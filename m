Return-Path: <linux-kernel-owner+w=401wt.eu-S1756216AbYAYQKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbYAYQKD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 11:10:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753530AbYAYQJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 11:09:51 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:48631 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbYAYQJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 11:09:50 -0500
Date: Fri, 25 Jan 2008 16:09:40 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: Michael Opdenacker <michael-lists@free-electrons.com>,
       Matt Mackall <mpm@selenic.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Linux-tiny@selenic.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: fix unconditional
	arch/x86/kernel/pcspeaker.c?compiling
Message-ID: <20080125160940.GB10907@linux-mips.org>
References: <200801171643.49301.michael-lists@free-electrons.com> <4790D3E3.4060409@free-electrons.com> <1200676219.3835.8.camel@cinder.waste.org> <200801232330.12331.michael-lists@free-electrons.com> <4798F11C.2020105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4798F11C.2020105@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2008 at 11:12:12PM +0300, Dmitri Vorobiev wrote:

> > running "make allnoconfig". To get it, you have to explicitely add support
> > to CONFIG_INPUT_PCSPKR (m or y). I hope this is fine.
> > 
> > I'm copying the MIPS maintainer as this patch touches his tree too.
> 
> This patch does not apply cleanly to linux-mips Git tree:
> 
> ----> snip
> patching file arch/x86/kernel/Makefile
> Hunk #1 FAILED at 69.
> 1 out of 1 hunk FAILED -- saving rejects to file arch/x86/kernel/Makefile.rej
> ----> snip
> 
> I believe this is because the linux-mips tree and the -mm tree are not in sync.

The main linux-mips git tree is derived of Linus' kernel.org tree and
I usually update it daily.  Patch scheduled for the next kernel release or
later go into a special tree from which akpm pulls.  For significant
patch submissions that means patches should be generated either against
the linux-queue tree from linux-mips.org (which only contains the MIPS
specific stuff) or possibly akpm's -mm tree.

  Ralf
