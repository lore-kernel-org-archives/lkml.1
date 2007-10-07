Return-Path: <linux-kernel-owner+w=401wt.eu-S1757732AbXJGXTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732AbXJGXTR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 19:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756182AbXJGXTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 19:19:04 -0400
Received: from barikada.upol.cz ([158.194.242.200]:55251 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbXJGXTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 19:19:01 -0400
Date: Mon, 8 Oct 2007 01:33:10 +0200
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Ingo Molnar <mingo@elte.hu>, Willy Tarreau <w@1wt.eu>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: Re: "Re: [PATCH 0/2] Colored kernel output (run2)" + "`Subject:' usage"
Message-ID: <20071007233310.GW22435@flower.upol.cz>
References: <20071006194820.GA30579@elte.hu> <20071006210349.GG22435@flower.upol.cz> <20071007060706.GA18768@elte.hu> <20071007111035.GO22435@flower.upol.cz> <20071007161255.GA22102@elte.hu> <470929D8.80003@keyaccess.nl> <20071007191309.GS10199@1wt.eu> <20071007211154.GA27685@elte.hu> <20071007230250.GV22435@flower.upol.cz> <Pine.LNX.4.64.0710080059500.16301@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710080059500.16301@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2007 at 01:01:33AM +0200, Jan Engelhardt wrote:
> 
> On Oct 8 2007 01:02, Oleg Verych wrote:
> >
> >If you are not going to see OOPes of new kernels running old distros, ask
> >any perl hacker (as they lovely mentioned in lkml) to hack for you
> >something like:
> >
> >sed -u -e '
> >/^<1/s_^_'$COLOR1'_
> >/^<2/s_^_'$COLOR2'_
> >/^<3/s_^_'$COLOR3'_
> >/^<4/s_^_'$COLOR4'_
> >/^<5/s_^_'$COLOR5'_
> >/^<6/s_^_'$COLOR6'_
> >/^<7/s_^_'$COLOR7'_
> >' < /proc/kmsg >/dev/tty
> >
> >place whole that perl shit on initrams of your kernel, run it in
> >background as early as possible with switched off default console output
> >(i.e. quiet boot).
> >
> >OVER.
> 
> Speaking of over, this does not fly at all. If you call panic(),
> for whatever reason you want, then the printk() is the last thing
> that happens after that, you can declare userspace dead.
> On oopses, it depends on their severity. Eventually procfs goes
> whoops and the kmsg transmission mechanism does not work, and oh,
> userspace can't help it.

I can rephrase/repeat: Here's discussion about general usage and feature
set.

The Development/debugging of the kernel, especially early boot or hard
core OOPs isn't covered. If a kernel developer wants to have nice looking
OOPes, i bet, this has nothing to do with general purpose printk() and
loglevels and the kernel, that usually must boot once, until next
security update.

This is just another debugging tool, that could be written faster than
any of the fancy rewrites of the kernel's core. Written many many
years ago with much reacher coloring features.
____
