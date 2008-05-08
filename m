Return-Path: <linux-kernel-owner+w=401wt.eu-S1757470AbYEHAWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470AbYEHAWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 20:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbYEHAVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 20:21:52 -0400
Received: from www.tglx.de ([62.245.132.106]:55295 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797AbYEHAVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 20:21:50 -0400
Date: Thu, 8 May 2008 02:21:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Rene Herman <rene.herman@keyaccess.nl>
cc: "H. Peter Anvin" <hpa@zytor.com>, Adrian Bunk <bunk@kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.26, PAT and AMD family 6
In-Reply-To: <48224507.8010102@keyaccess.nl>
Message-ID: <alpine.LFD.1.10.0805080214070.3318@apollo.tec.linutronix.de>
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de> <48221AE3.6020602@keyaccess.nl>
 <482233F0.7040000@zytor.com> <48224318.8020209@keyaccess.nl> <48224361.5080102@zytor.com> <48224507.8010102@keyaccess.nl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2008, Rene Herman wrote:
> On 08-05-08 02:03, H. Peter Anvin wrote:
> > Rene Herman wrote:
> > > > 
> > > > Okay, that is utter nonsense.  /proc/cpuinfo has always been, and will
> > > > always be, the CPU *AS THE KERNEL SEES IT*.  If you want something else,
> > > > use x86info(1).
> > > 
> > > What a lovely way of syncing reality with your definitions. The kernel
> > > _does_ see that my CPU features PAT, it just refuses to use it because
> > > it doesn't trust it enough. Vital difference. Maybe not to the kernel,
> > > but definitely to me, the user. /proc/cpuinfo is a user interface.
> > > 
> > 
> > No, /proc/cpuinfo is informing the user about the kernel's view of the CPU.
> 
> And again, the kernel DOES see that my CPU features PAT, it just refuses
> to use it.

Yuck, because your CPU has the PAT feature the kernel has an obligation
to support it ?

Nice try.

	tglx
