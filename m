Return-Path: <linux-kernel-owner+w=401wt.eu-S1754641AbYAHUOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbYAHUOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 15:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbYAHUOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 15:14:25 -0500
Received: from nz-out-0506.google.com ([64.233.162.233]:39003 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbYAHUOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 15:14:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Tiz/aTdZWflEgCAMgmlKQd0x6tzVoJwwkqj2K8KuoqeUf5yztcjJW4R71wV8Hclz1UNBDBCQqZgbt0Y4LA/Vy23HSxOyl2U7j63hEK/v21l8Uj5kHlDKKvCniUuWRQRTXt16rD92OnTomSObpMRa904eP/4hHaCzWZXQA5n+Oao=
Message-ID: <4d8e3fd30801081214v43294520h36e2da6df2bb3fe2@mail.gmail.com>
Date: Tue, 8 Jan 2008 21:14:22 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: [PATCH 4/5] x86: coding style fixes in arch/x86/ia32/ia32_binfmt.c
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>, trivial@kernel.org
In-Reply-To: <20080108200250.GC4627@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080108203242.5e033d97@paolo-desktop>
	 <20080108200250.GC4627@martell.zuzino.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 8, 2008 9:02 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> >  static void elf32_init(struct pt_regs *regs)
> >  {
> > -     struct task_struct *me = current;
> > +     struct task_struct *me = current;
> >       regs->rdi = 0;
> >       regs->rsi = 0;
> >       regs->rdx = 0;
> >       regs->rcx = 0;
> >       regs->rax = 0;
> > -     regs->rbx = 0;
> > -     regs->rbp = 0;
> > +     regs->rbx = 0;
> > +     regs->rbp = 0;
> >       regs->r8 = regs->r9 = regs->r10 = regs->r11 = regs->r12 =
> > -             regs->r13 = regs->r14 = regs->r15 = 0;
> > -    me->thread.fs = 0;
> > +             regs->r13 = regs->r14 = regs->r15 = 0;
> > +    me->thread.fs = 0;
> >       me->thread.gs = 0;
> > -     me->thread.fsindex = 0;
> > +     me->thread.fsindex = 0;
> >       me->thread.gsindex = 0;
> > -    me->thread.ds = __USER_DS;
> > +    me->thread.ds = __USER_DS;
>
> No re-indenting those 4-spaced lines? I mean if you're in CodindStyle
> compliance business driving from 99 to 99.9 percents please do it well
> at least.

Neither checkpatch.pl nor my .vimrc triggered those lines :-/

If Ingo wants to apply the patch I'll update it.

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
