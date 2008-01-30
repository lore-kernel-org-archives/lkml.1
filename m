Return-Path: <linux-kernel-owner+w=401wt.eu-S1756247AbYA3Vjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247AbYA3Vjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:39:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbYA3VjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:39:19 -0500
Received: from lixom.net ([66.141.50.11]:48301 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbYA3VjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:39:18 -0500
Date: Wed, 30 Jan 2008 15:39:26 -0600
From: Olof Johansson <olof@lixom.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>, anton@samba.org,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       "Luck, Tony" <tony.luck@intel.com>, sparclinux@vger.kernel.org,
       linux-ia64@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Mike Travis <travis@sgi.com>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [powerpc changes] Re: x86/non-x86: percpu, node ids, apic ids
	x86.git fixup
Message-ID: <20080130213926.GA22841@lixom.net>
References: <200801301414.m0UEEgCC006371@hera.kernel.org> <Pine.LNX.4.64.0801301622460.11859@vixen.sonytel.be> <47A09F8A.3000309@sgi.com> <20080130161036.GA12293@elte.hu> <1FE6DD409037234FAB833C420AA843EC757C72@orsmsx424.amr.corp.intel.com> <20080130180623.GA24881@elte.hu> <1FE6DD409037234FAB833C420AA843EC757DEA@orsmsx424.amr.corp.intel.com> <20080130184920.GA32212@elte.hu> <20080130191302.GA20008@lixom.net> <20080130212558.GA12409@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130212558.GA12409@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 10:25:58PM +0100, Ingo Molnar wrote:
> 
> * Olof Johansson <olof@lixom.net> wrote:
> 
> > > could you try the full patchset that Travis has just sent and which 
> > > i've put into x86.git, you can pull it from:
> > 
> > Looks ok for powerpc so far, I haven't gotten through all defconfigs 
> > yet but the first ones that failed before build now. pasemi_defconfig 
> > boots as well.
> 
> could the PowerPC maintainers please Ack the following patch (attached 
> below):
> 
>   Subject: POWERPC: use generic per cpu
>   From: travis@sgi.com
> 
> so that we can push this fix upstream ASAP?

> Subject: POWERPC: use generic per cpu
> From: travis@sgi.com
> 
> Powerpc has a way to determine the address of the per cpu area of the
> currently executing processor via the paca and the array of per cpu
> offsets is avoided by looking up the per cpu area from the remote
> paca's (copying x86_64).
> 
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> Signed-off-by: Mike Travis <travis@sgi.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Paul is at LCA, I'm not sure if he's reading email. Looks good to me so:

Acked-by: Olof Johansson <olof@lixom.net>


-Olof
