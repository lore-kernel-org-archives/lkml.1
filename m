Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbXKUCT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbXKUCT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 21:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbXKUCTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 21:19:49 -0500
Received: from wx-out-0506.google.com ([66.249.82.234]:28671 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbXKUCTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 21:19:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IYAI9cka1wh3e82G+Q0kKfp+yBIS4zOADJL5WtpCuwTkOLTnnGhG25F3nHgbak76vMKAvW0VCESPTeiT+OKda6IiSgDLe0Hp3gvJCLmN+SCSOwDF+uA4VXvi/nPwR/EOFilgilfwp5JgBjISASgsg7Dcj2HhsONY5t0y/GptAnw=
Message-ID: <a8e1da0711201819i462758a5t609e5df9072813ee@mail.gmail.com>
Date: Wed, 21 Nov 2007 10:19:46 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [BUG] 2.6.24-rc2-mm1 Warning at arch/x86/kernel/smp_32.c:561
Cc: linux-kernel@vger.kernel.org, "Mark Gross" <mgross@linux.intel.com>
In-Reply-To: <a8e1da0711200159h393d8787r9abcc7d1807401b1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071120094728.GA12096@darkstar.te-china.tietoenator.com>
	 <20071120015600.50a1f5f1.akpm@linux-foundation.org>
	 <a8e1da0711200159h393d8787r9abcc7d1807401b1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 20, 2007 5:59 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
>
> On Nov 20, 2007 5:56 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Tue, 20 Nov 2007 17:47:28 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:
> >
> > > Hi,
> > > I encountered kernel warningsr. I just executed xawtv without video dev being found.
> > >
> > > like this:
> > >
> > > WARNING: at arch/x86/kernel/smp_32.c:561 native_smp_call_function_mask()
> > >  [<c0118769>] native_smp_call_function_mask+0x149/0x150
> > >  [<c0178dd9>] alloc_debug_processing+0xa9/0x130
> > >  [<c0372da0>] smp_callback+0x0/0x10
> > >  [<c0119b7c>] smp_call_function+0x1c/0x20
> > >  [<c0372dc8>] cpuidle_latency_notify+0x18/0x20
> > >  [<c0144eae>] notifier_call_chain+0x3e/0x70
> > >  [<c01450d4>] __blocking_notifier_call_chain+0x44/0x70
> > >  [<c0145117>] blocking_notifier_call_chain+0x17/0x20
> > >  [<c01454fd>] pm_qos_add_requirement+0x8d/0xd0
> > >  [<f887030c>] snd_pcm_hw_params+0x20c/0x2a0 [snd_pcm]
> > >  [<f88703ee>] snd_pcm_hw_params_user+0x4e/0x90 [snd_pcm]
> > >  [<f88741ed>] snd_pcm_capture_ioctl1+0x3d/0x230 [snd_pcm]
> > >  [<f88c1b28>] snd_pcm_hw_param_near+0x198/0x230 [snd_pcm_oss]
> > >  [<f88744fe>] snd_pcm_kernel_ioctl+0x7e/0x90 [snd_pcm]
> > >  [<f88c28fc>] snd_pcm_oss_change_params+0x2fc/0x750 [snd_pcm_oss]
> > >  [<f88c2e47>] snd_pcm_oss_make_ready+0x47/0x60 [snd_pcm_oss]
> > >  [<f88c3a4e>] snd_pcm_oss_sync+0x10e/0x290 [snd_pcm_oss]
> > >  [<f88c4daa>] snd_pcm_oss_release+0x9a/0xb0 [snd_pcm_oss]
> > >  [<c01801ae>] __fput+0x16e/0x200
> > >  [<c017e35c>] filp_close+0x3c/0x80
> > >  [<c017e409>] sys_close+0x69/0xd0
> > >  [<c01042da>] syscall_call+0x7/0xb
> > >  [<c0400000>] xfrm_notify_sa+0x110/0x290
> > >  =======================
> > >
> >
> > That was hopefully fixed.  You might care to test
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-11-20-01-45.tar.gz
> > to confirm that, if feeling sufficiently brave..
> >
>

Hi,
I just confirm that I can't reproduce this after apply
broken-out-2007-11-20-01-45 patch set.

Regards
dave
