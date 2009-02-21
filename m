Return-Path: <linux-kernel-owner+w=401wt.eu-S1754389AbZBUKVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbZBUKVb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 05:21:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbZBUKVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 05:21:23 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:54845 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbZBUKVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 05:21:22 -0500
From: Philippe Grenard <philippe.grenard@laposte.net>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: PROBLEM: cannot get stable system since 2.6.28 kernel (amd64)
Date: Sat, 21 Feb 2009 11:21:46 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.27.17; KDE/4.2.0; x86_64; ; )
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, John Stoffel <john@stoffel.org>
References: <200902131944.56634.philippe.grenard@laposte.net> <200902202108.55332.philippe.grenard@laposte.net> <20090220215830.GB30665@elte.hu>
In-Reply-To: <20090220215830.GB30665@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902211121.46292.philippe.grenard@laposte.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 February 2009 22:58:30 Ingo Molnar wrote:
> * Philippe Grenard <philippe.grenard@laposte.net> wrote:
> > dc1e35c6e95e8923cf1d3510438b63c600fee1e2 is first bad commit
> > commit dc1e35c6e95e8923cf1d3510438b63c600fee1e2
> > Author: Suresh Siddha <suresh.b.siddha@intel.com>
> > Date:   Tue Jul 29 10:29:19 2008 -0700
> >
> >     x86, xsave: enable xsave/xrstor on cpus with xsave support
>
> [...]
>
> > A bit of googling gave me this :
> > http://lkml.org/lkml/2009/1/19/161
> > which exactly corresponds to my problem with 2.6.28 !
> >
> > A "solution" proposed was to try to check the bios setting
> > "cpuid value limit" and disable it if enabled. This did help
> > me to boot 2.6.28 or previously failing kernel compiled during
> > git-bisect, but gave me the "random freeze" any way....
>
> Note that the workaround for that BIOS bug is already in the
> latest upstream kernel, i.e. in 2.6.29-rc5.
>
> Could you please try -rc5, whether it works out of box?
>
> If you still see freezes, could you try the "nofxsr" boot
> option? That will turn off the new FPU code both in the hw and
> in the kernel.
>
> 	Ingo

Hello Ingo, thanks for your reply,

I've tried to boot 2.6.29-rc5 with both "Max CPUID Value" Enabled and 
Disabled, and tried for both case the "nofxsr" option without better result...

As I said before, I use the default dsdt table : can this be a problem too ?

Philippe
