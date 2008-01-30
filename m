Return-Path: <linux-kernel-owner+w=401wt.eu-S1764354AbYA3TNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764354AbYA3TNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 14:13:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757491AbYA3TM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 14:12:56 -0500
Received: from lixom.net ([66.141.50.11]:41707 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181AbYA3TMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:12:55 -0500
Date: Wed, 30 Jan 2008 13:13:02 -0600
From: Olof Johansson <olof@lixom.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Luck, Tony" <tony.luck@intel.com>, sparclinux@vger.kernel.org,
       linux-ia64@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Mike Travis <travis@sgi.com>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: x86/non-x86: percpu, node ids, apic ids x86.git fixup
Message-ID: <20080130191302.GA20008@lixom.net>
References: <200801301414.m0UEEgCC006371@hera.kernel.org> <Pine.LNX.4.64.0801301622460.11859@vixen.sonytel.be> <47A09F8A.3000309@sgi.com> <20080130161036.GA12293@elte.hu> <1FE6DD409037234FAB833C420AA843EC757C72@orsmsx424.amr.corp.intel.com> <20080130180623.GA24881@elte.hu> <1FE6DD409037234FAB833C420AA843EC757DEA@orsmsx424.amr.corp.intel.com> <20080130184920.GA32212@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130184920.GA32212@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 07:49:20PM +0100, Ingo Molnar wrote:
> 
> * Luck, Tony <tony.luck@intel.com> wrote:
> 
> > > Could you check the patch below? With this applied to latest -git, 
> > > ia64 buils fine for me in a cross-compiling environment. (but i dont 
> > > know whether it boots ...)
> > 
> > Uni-processor build still fails with this patch (config is 
> > arch/ia64/configs/tiger_defconfig with CONFIG_SMP switched from =y to 
> > =n).
> 
> could you try the full patchset that Travis has just sent and which i've 
> put into x86.git, you can pull it from:

Looks ok for powerpc so far, I haven't gotten through all defconfigs yet
but the first ones that failed before build now. pasemi_defconfig boots
as well.


-Olof
