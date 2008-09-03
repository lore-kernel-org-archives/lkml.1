Return-Path: <linux-kernel-owner+w=401wt.eu-S1755711AbYICTVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbYICTVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 15:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbYICTVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 15:21:12 -0400
Received: from inhex.net ([193.33.178.145]:45065 "EHLO inhex.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbYICTVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 15:21:12 -0400
Date: Wed, 3 Sep 2008 22:21:00 +0300
From: Dmitry Nezhevenko <dion@inhex.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       herton@mandriva.com.br,
       Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Glauber Costa <gcosta@redhat.com>
Subject: Re: 2.6.27-rc5 doesn't boot on a Pavilion laptop
Message-ID: <20080903192100.GA9643@laptop.local>
References: <alpine.LFD.1.10.0809031202290.3243@apollo.tec.linutronix.de> <20080903104132.7a736282@doriath.conectiva> <alpine.LFD.1.10.0809031635260.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809031713040.3243@apollo.tec.linutronix.de> <20080903164415.GA24442@laptop.local> <alpine.LFD.1.10.0809031857020.3243@apollo.tec.linutronix.de> <20080903143653.68bb58df@doriath.conectiva> <alpine.LFD.1.10.0809032030271.3243@apollo.tec.linutronix.de> <20080903190105.GA3660@laptop.local> <alpine.LFD.1.10.0809032105160.3243@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809032105160.3243@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 09:08:41PM +0200, Thomas Gleixner wrote:
> > > Does the patch below help ? Keep the debug patch applied, as we can
> > > see whether the check triggers or not.
> > 
> > Works for me... I'm just got only second backtrace after mounting rootfs.
> > Looks like something is broken with  git tree. 
> 
> Is the box continuing to work after that warning/backtrace ? This is
> still on the x86 git tree, right ? Please verify whether mainline
> (linus git tree) has the same problem.
> 

I've just tried 2.6.27-rc5 vanilla with two your patches. It works as
expected without any kind of warnings/backtraces. 

Not attaching dmesg, because it's just clean. If you need it, please
download from:
http://inhex.net/dion/lkml/dmesg_hpet_fix.txt

If this patch will be commited to mainline, bug #11101 can be closed as
fixed.

PS. CC-ed Glauber, because #11101 is assigned to him.

-- 
WBR, Dmitry
