Return-Path: <linux-kernel-owner+w=401wt.eu-S1752835AbYJCJKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbYJCJKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 05:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbYJCJKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 05:10:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54446 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424AbYJCJKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 05:10:21 -0400
Date: Fri, 3 Oct 2008 11:10:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Russ Anderson <rja@sgi.com>
Cc: huang ying <huang.ying.caritas@gmail.com>,
       Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [PATCH 2/4] x86: Add UV bios call infrastructure v2
Message-ID: <20081003091012.GF27551@elte.hu>
References: <20080926200242.GC138671@sgi.com> <1222478495.28661.19.camel@yhuang-dev.sh.intel.com> <20080928150106.GA204845@sgi.com> <851fc09e0810020102j7c4f8896vd384f79617480317@mail.gmail.com> <20081002153403.GA153543@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081002153403.GA153543@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Russ Anderson <rja@sgi.com> wrote:

> On Thu, Oct 02, 2008 at 04:02:00PM +0800, huang ying wrote:
> > On Sun, Sep 28, 2008 at 11:01 PM, Russ Anderson <rja@sgi.com> wrote:
> > >
> > > efi_call_virt6() uses efi.systab->runtime->f.
> > > My call needs to use uv_systab, not efi.systab.
> > 
> > Yes. efi_call_virt6() is tied with standard EFI runtime services, so
> > it may be not suitable for your need. What you need is just to do
> > calling convention converting, like efi_call6 does. So I think it is
> > better to just use your current implementation.
> > 
> > Acked-by: Huang Ying <ying.huang@intel.com>
> 
> Thanks.  Ingo, that is the v2 version of the patchset.

ok - could you please resend the lot with all the Acked-by's in place? 
(and with all the bits that are being objected left out)

	Ingo
