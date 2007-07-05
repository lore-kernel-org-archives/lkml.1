Return-Path: <linux-kernel-owner+w=401wt.eu-S1760286AbXGEJjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760286AbXGEJjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 05:39:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758507AbXGEJi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 05:38:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38765 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758431AbXGEJi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 05:38:57 -0400
Date: Thu, 5 Jul 2007 11:38:42 +0200
From: Stefan Seyfried <seife@suse.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, nigel@nigel.suspend2.net,
       linux-kernel@vger.kernel.org, suspend-devel@lists.sourceforge.net,
       Frank Seidel <fseidel@suse.de>
Subject: Re: [RFC] get rid of CONFIG_DISABLE_CONSOLE_SUSPEND
Message-ID: <20070705093842.GA3175@suse.de>
References: <20070628135108.GA1810@elf.ucw.cz> <200706281734.54642.rjw@sisk.pl> <20070704193313.GF2728@elf.ucw.cz> <200707042344.25207.rjw@sisk.pl> <20070704223921.GA2491@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070704223921.GA2491@elf.ucw.cz>
X-Operating-System: openSUSE 10.3 (i586) Alpha5plus, Kernel 2.6.22-rc7-2-default
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jul 05, 2007 at 12:39:22AM +0200, Pavel Machek wrote:
> Hi!
> 
> > Yes, but I'm not sure if netconsole is the only one that we will want to have
> 
> Well, netconsole is the only one we know of.

AFAIR it is plain luck that serial console sometimes works.

I repeat: "no bugreport" is not the same as "it works for everyone" wrt.
suspend. It seems (i unfortunately have no numbers, since my machines always
worked without suspending the consoles) as if suspending consoles generally
helped reliability of suspend.
 
> > disabled.  Moreover, what if someone wants to use the netconsole regardless
> > of the fact that it can crash the box?
> 
> He'll have to edit the sources at that point. I'd prefer not to have
> too many "please crash the box" options.

So should we remove sysrq-C?
This is a debugging option. Only root can set it. Its purpose is to make
"machine hangs during suspend" (even before it goes to sleep) debuggable.
It will only be set if the machine crashes anyways.

(We can taint the kernel if this control is set, if that helps you).
-- 
Stefan Seyfried
QA / R&D Team Mobile Devices        |              "Any ideas, John?"
SUSE LINUX Products GmbH, Nürnberg  | "Well, surrounding them's out." 

This footer brought to you by insane German lawmakers:
SUSE Linux Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
