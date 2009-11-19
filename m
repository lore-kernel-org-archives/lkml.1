Return-Path: <linux-kernel-owner+w=401wt.eu-S1753283AbZKSNXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbZKSNXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbZKSNXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:23:18 -0500
Received: from www.tglx.de ([62.245.132.106]:38160 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbZKSNXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:23:16 -0500
Date: Thu, 19 Nov 2009 14:22:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Jean Delvare <khali@linux-fr.org>,
       Leon Woestenberg <leon.woestenberg@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       linux-i2c@vger.kernel.org, rt-users <linux-rt-users@vger.kernel.org>,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: yield() in i2c non-happy paths hits BUG under -rt patch
In-Reply-To: <1258636872.4372.354.camel@twins>
Message-ID: <alpine.LFD.2.00.0911191421450.24119@localhost.localdomain>
References: <c384c5ea0911071101u7415d37o2611c542e5fae309@mail.gmail.com>  <20091107210147.3e754278@hyperion.delvare>  <4AF7148C.9090706@thebigcorporation.com>  <20091112211255.09cd884a@hyperion.delvare>  <alpine.LFD.2.00.0911132139560.24119@localhost.localdomain>
  <20091116155606.GC29479@sirena.org.uk>  <c384c5ea0911171650t1c441dc4v746d31e4154fcb30@mail.gmail.com>  <20091118010520.4cd397d4@lxorguk.ukuu.org.uk>  <c384c5ea0911180828x7c857189w3316c93bb78100ab@mail.gmail.com>  <20091118175202.490989d8@hyperion.delvare>
  <alpine.LFD.2.00.0911182127040.24119@localhost.localdomain>  <20091119130526.23a69b85@hyperion.delvare>  <alpine.LFD.2.00.0911191357490.24119@localhost.localdomain> <1258636872.4372.354.camel@twins>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Nov 2009, Peter Zijlstra wrote:

> On Thu, 2009-11-19 at 14:11 +0100, Thomas Gleixner wrote:
> > > You say "NOOP by default", does this imply there is a way to change
> > > this?
> > 
> > There is a sysctl: sysctl_sched_compat_yield 
> 
> This makes yield() place current behind all other tasks, and sucks too
> for some workloads.

yield() sucks anyway, so it depends which flavour of suckage you
prefer.

    tglx
