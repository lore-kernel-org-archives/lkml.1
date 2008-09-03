Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbYICTgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbYICTgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 15:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbYICTgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 15:36:22 -0400
Received: from www.tglx.de ([62.245.132.106]:44681 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbYICTgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 15:36:20 -0400
Date: Wed, 3 Sep 2008 21:35:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dmitry Nezhevenko <dion@inhex.net>
cc: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       herton@mandriva.com.br,
       Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Glauber Costa <gcosta@redhat.com>
Subject: Re: 2.6.27-rc5 doesn't boot on a Pavilion laptop
In-Reply-To: <20080903192100.GA9643@laptop.local>
Message-ID: <alpine.LFD.1.10.0809032132140.3243@apollo.tec.linutronix.de>
References: <alpine.LFD.1.10.0809031202290.3243@apollo.tec.linutronix.de> <20080903104132.7a736282@doriath.conectiva> <alpine.LFD.1.10.0809031635260.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809031713040.3243@apollo.tec.linutronix.de>
 <20080903164415.GA24442@laptop.local> <alpine.LFD.1.10.0809031857020.3243@apollo.tec.linutronix.de> <20080903143653.68bb58df@doriath.conectiva> <alpine.LFD.1.10.0809032030271.3243@apollo.tec.linutronix.de> <20080903190105.GA3660@laptop.local>
 <alpine.LFD.1.10.0809032105160.3243@apollo.tec.linutronix.de> <20080903192100.GA9643@laptop.local>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008, Dmitry Nezhevenko wrote:

> On Wed, Sep 03, 2008 at 09:08:41PM +0200, Thomas Gleixner wrote:
> > > > Does the patch below help ? Keep the debug patch applied, as we can
> > > > see whether the check triggers or not.
> > > 
> > > Works for me... I'm just got only second backtrace after mounting rootfs.
> > > Looks like something is broken with  git tree. 
> > 
> > Is the box continuing to work after that warning/backtrace ? This is
> > still on the x86 git tree, right ? Please verify whether mainline
> > (linus git tree) has the same problem.
> > 
> 
> I've just tried 2.6.27-rc5 vanilla with two your patches. It works as
> expected without any kind of warnings/backtraces. 
> 
> Not attaching dmesg, because it's just clean. If you need it, please
> download from:
> http://inhex.net/dion/lkml/dmesg_hpet_fix.txt
> 
> If this patch will be commited to mainline, bug #11101 can be closed as
> fixed.
> 
> PS. CC-ed Glauber, because #11101 is assigned to him.

Well, we better find out what's wrong in the x86 tree _before_ it hits
2.6.28. So please keep the bug open, so we don't have to reopen it
after 2.6.28-rc1. This IPI warning needs to be anaylsed.

Thanks,

	tglx
