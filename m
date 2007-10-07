Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbXJGTd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbXJGTd0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 15:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754861AbXJGTdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 15:33:18 -0400
Received: from barikada.upol.cz ([158.194.242.200]:53447 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbXJGTdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 15:33:17 -0400
Date: Sun, 7 Oct 2007 21:47:25 +0200
To: Willy Tarreau <w@1wt.eu>
Cc: Rene Herman <rene.herman@keyaccess.nl>, Ingo Molnar <mingo@elte.hu>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: Re: "Re: [PATCH 0/2] Colored kernel output (run2)" + "`Subject:' usage"
Message-ID: <20071007194725.GS22435@flower.upol.cz>
References: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr> <20071006195105.GE22435@flower.upol.cz> <20071006194820.GA30579@elte.hu> <20071006210349.GG22435@flower.upol.cz> <20071007060706.GA18768@elte.hu> <20071007111035.GO22435@flower.upol.cz> <20071007161255.GA22102@elte.hu> <470929D8.80003@keyaccess.nl> <20071007191309.GS10199@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071007191309.GS10199@1wt.eu>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 07, 2007 at 09:13:09PM +0200, Willy Tarreau wrote:
> On Sun, Oct 07, 2007 at 08:47:52PM +0200, Rene Herman wrote:
> > On 10/07/2007 06:12 PM, Ingo Molnar wrote:
> > 
> > >* Oleg Verych <olecom@flower.upol.cz> wrote:
> > 
> > >>Coloring isn't useful. If it was, it would be implemented ~16 years
> > >>ago.
> > >
> > >Congratulations, this is the most stupid argument i've ever read on 
> > >lkml.
[]
> I would say that while I'm not particularly fond of flashy colors
> everywhere, I think that being able to use colors to indicate particular
> actions in progress or conditions can be a good thing. RAID errors,
> devices disabled due to command-line parameters, and general anomalies
> which can cause a hang or panic a few line laters are worth coloring.

That *is* the coloring, i'm talking about.

> And I don't believe in userland's help here, because for that type of
> messages, the indication should be returned immediately.

In the very buggy cases, i think, everything just hang. Otherwise
initramfs stuff can deal with it.

> For instance, anyone who has experienced read errors on and IDE disk
> knows that it can literally take hours/days to boot, after displaying
> thousands of messages. Here, having the ability to see that no IRQ was
> assigned or something like this could help.

As i'm pretty much in all that text(tty)-mode stuff anyway, maybe after
some time i will propose something klibc/tty based. Mainly a bit of user
interface: split scrolling regions for errors and notifications; flexible
color schemas (keyword highlighting); keyboard events. Of course it will
work in such IDE cases, only if driver is a module.
____
