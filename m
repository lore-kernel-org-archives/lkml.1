Return-Path: <linux-kernel-owner+w=401wt.eu-S1763767AbXFRObg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763767AbXFRObg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 10:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761776AbXFROb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 10:31:29 -0400
Received: from mail.gmx.net ([213.165.64.20]:47260 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756821AbXFROb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 10:31:28 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1803XootZ40aWsmkeW0ryjHmzkmlkn/O20w0GzKOx
	UGiGwJCYX+WOVX
Date: Mon, 18 Jun 2007 16:31:25 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.22-rc3 nmi watchdog hang
Message-ID: <20070618143124.GA4508@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20070605091151.GA18385@elte.hu> <20070605022411.f303d28b.akpm@linux-foundation.org> <20070605093349.GA24956@elte.hu> <20070605093958.GA26135@elte.hu> <20070605094246.GA27135@elte.hu> <20070605094555.GA28097@elte.hu> <20070605095025.GA29029@elte.hu> <20070605095600.GA29270@elte.hu> <20070610181016.GA15979@atjola.homenet> <20070618121122.GA14375@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070618121122.GA14375@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.06.18 14:11:22 +0200, Ingo Molnar wrote:
> 
> * Björn Steinbrink <B.Steinbrink@gmx.de> wrote:
> 
> > >      [PATCH] i386: Clean up NMI watchdog code
> > > 
> > > Andi - just boot with nmi_watchdog=2 on a dual-core Athlon64 CPU.
> > 
> > I still fail to reproduce this, could you send me your config?
> 
> attached below. nmi_watchdog=2 still hangs as of -rc5, using the 32-bit 
> kernel (at various places during bootup - a typical place is somewhere 
> after cfq_init()). Changing it to nmi_watchdog=0 makes the kernel boot 
> again.

Still no hang here. Just to make sure that I didn't mess the test up,
here's what I did:

Get pristine 2.6.22-rc5 kernel sources.
Put your config in place as .config
Run: make ARCH=i386 CFLAGS_KERNEL="-m32" AFLAGS_KERNEL="-m32"
Install the kernel.
Reboot, pass "nmi_watchdog=2" as kernel parameter.

As your config is for a 64bit kernel, several config items had to be set
manually. In one run, I accepted the default values, in the second run,
I tried to adjust those items to match your 64bit config as good as I
could.

Anything wrong with that?

Björn
