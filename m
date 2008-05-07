Return-Path: <linux-kernel-owner+w=401wt.eu-S1762636AbYEGU7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762636AbYEGU7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 16:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbYEGU6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 16:58:49 -0400
Received: from www.tglx.de ([62.245.132.106]:42366 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761210AbYEGU6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 16:58:45 -0400
Date: Wed, 7 May 2008 22:58:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mirco Tischler <mt-ml@gmx.de>
cc: Ingo Molnar <mingo@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [BUG]:WARNING: at arch/x86/kernel/rtc.c:122 in 2.6.26-rc1
In-Reply-To: <1210188734.5456.14.camel@mtlp.tischlernetz>
Message-ID: <alpine.LFD.1.10.0805072253480.3318@apollo.tec.linutronix.de>
References: <1210183536.28099.10.camel@mtlp.tischlernetz>  <alpine.LFD.1.10.0805072102010.3318@apollo.tec.linutronix.de> <1210188734.5456.14.camel@mtlp.tischlernetz>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2008, Mirco Tischler wrote:

> On Mi, 2008-05-07 at 21:06 +0200, Thomas Gleixner wrote:
> > > [11677.490019] CPU1 is down
> > > [11677.490149] Extended CMOS year: 2000
> > > [11677.490149] x86 PAT enabled: cpu 0, old 0x7040600070406, new
> > > 0x7010600070106
> > > [11677.490747] Back to C!
> > > [11677.490952] microcode: CPU0 updated from revision 0x92 to 0x92, date
> > > = 03132007 

That's an odd one: updated from revision 0x92 to 0x92

It's right before the warning triggers. Is this microcode message in
all your boot/resume logs ?

> Just ask if you need more specific information.

See above ::

Thanks,
	tglx
