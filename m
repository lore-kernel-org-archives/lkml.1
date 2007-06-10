Return-Path: <linux-kernel-owner+w=401wt.eu-S1762130AbXFJSKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762130AbXFJSKX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 14:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755714AbXFJSKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 14:10:11 -0400
Received: from mail.gmx.net ([213.165.64.20]:56184 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754666AbXFJSKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 14:10:09 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX19047hFqpt087U2eMMrytO59S6uMXXiIkBS/tK7o9
	bFZJH6wSQlGpFJ
Date: Sun, 10 Jun 2007 20:10:16 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.22-rc3 nmi watchdog hang
Message-ID: <20070610181016.GA15979@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20070530235823.793f00d9.akpm@linux-foundation.org> <20070605091151.GA18385@elte.hu> <20070605022411.f303d28b.akpm@linux-foundation.org> <20070605093349.GA24956@elte.hu> <20070605093958.GA26135@elte.hu> <20070605094246.GA27135@elte.hu> <20070605094555.GA28097@elte.hu> <20070605095025.GA29029@elte.hu> <20070605095600.GA29270@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070605095600.GA29270@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.06.05 11:56:00 +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > ah, plain -rc3 hangs too. So it's one of these commits i guess:
> > > 
> > > commit 1eeb66a1bb973534dc3d064920a5ca683823372e
> > > commit 09198e68501a7e34737cd9264d266f42429abcdc
> > > commit bbba11c35baaad3f70f32e185a2c1d40d7901fe9
> > > commit bf8696ed6dfa561198b4736deaf11ab68dcc4845
> > 
> > oh, damn. The resulting kernel after having undone these doesnt even 
> > build ...
> 
> Andi/Linus Cc:-ed - these NMI watchdog changes came over the x86_64 
> tree. I suspect this patch:
> 
>  commit 09198e68501a7e34737cd9264d266f42429abcdc
>  Author: Andi Kleen <ak@suse.de>
>  Date:   Wed May 2 19:27:20 2007 +0200
> 
>      [PATCH] i386: Clean up NMI watchdog code
> 
> Andi - just boot with nmi_watchdog=2 on a dual-core Athlon64 CPU.

I still fail to reproduce this, could you send me your config?

Thanks,
Björn
