Return-Path: <linux-kernel-owner+w=401wt.eu-S1761666AbYERMek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761666AbYERMek (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 08:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbYERMec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 08:34:32 -0400
Received: from www.tglx.de ([62.245.132.106]:49172 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912AbYERMeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 08:34:31 -0400
Date: Sun, 18 May 2008 14:33:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #10710] [BISECTED] Lots of "rescheduling IPIs" in
 powertop
In-Reply-To: <19f34abd0805180523o12732812k87b8ddd832843af4@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0805181429230.18798@apollo.tec.linutronix.de>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>  <7wuznNhcUqC.A.xiH.EsBMIB@albercik> <19f34abd0805180523o12732812k87b8ddd832843af4@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 May 2008, Vegard Nossum wrote:
> On Sun, May 18, 2008 at 1:13 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10710
> > Subject         : [BISECTED] Lots of "rescheduling IPIs" in powertop
> > Submitter       : Vegard Nossum <vegard.nossum@gmail.com>
> > Date            : 2008-05-13 20:42 (6 days old)
> > References      : http://marc.info/?l=linux-kernel&amp;m=121071176205864&amp;w=4
> > Handled-By      : Andi Kleen <andi@firstfloor.org>
> >                  Arjan van de Ven <arjan@infradead.org>
> >                  Ingo Molnar <mingo@elte.hu>
> > Patch           : http://marc.info/?l=linux-kernel&amp;m=121074826823352&amp;w=4
> >
> 
> Ingo Molnar provided the patch that solved the problem (the referenced
> link) but he wanted to wait for Andreas Herrmann to provide an
> additional patch that would solve some implication on AMD CPUs. So
> this is in theory fixed, but the fix has not yet been applied anywhere
> as far as I know.

Both fixes are in

http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-x86.git;a=shortlog;h=x86-fixes-for-linus

which was pulled by Linus yesterday, but he did not push them out to
his tree yet.

Thanks,

	tglx
