Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbYAGTXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbYAGTXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 14:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbYAGTXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 14:23:08 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:56537 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176AbYAGTXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 14:23:07 -0500
Date: Mon, 7 Jan 2008 20:22:59 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: John Reiser <jreiser@BitWagon.com>
Cc: Paul Mackerras <paulus@samba.org>, Hirokazu Takata <takata@linux-m32r.org>,
       "David S. Miller" <davem@davemloft.net>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>, Greg Ungerer <gerg@uclinux.org>,
       Mikael Starvik <starvik@axis.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: STT_FUNC for assembler checksum and semaphore ops
Message-ID: <20080107192259.GC16710@uranus.ravnborg.org>
References: <47826019.9040607@BitWagon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47826019.9040607@BitWagon.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2008 at 09:23:37AM -0800, John Reiser wrote:
> Dear $ARCH Maintainers,
> 
> This patch adds Elf32_Sym .st_info (STT_FUNC) and .st_size for hand-coded
> checksum and semaphore subroutines.  I needed this info when writing a
> static analyzer for stack depth [grovel over ./vmlinux] on the um
> (UserModeLinux) $ARCH for i386.  The changes work on i386.  Other $ARCH
> are analogous but not tested.  Other arch/x86/lib/*.S are not used by um
> currently.  [Should analogous changes be made anyway?]
> 
> Comments?

I do not know the assembly stuff in question,
but the code you add would be nicer if packed in a macro.
You may even use _GLOBAL and/or ENTRY for your purpose.

	Sam
