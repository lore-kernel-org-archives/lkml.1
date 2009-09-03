Return-Path: <linux-kernel-owner+w=401wt.eu-S1756531AbZICXP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbZICXP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 19:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755288AbZICXP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 19:15:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39227 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752001AbZICXP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 19:15:26 -0400
Date: Thu, 3 Sep 2009 16:14:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: petkovbb@googlemail.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
       kjwinchester@gmail.com, tglx@linutronix.de, borislav.petkov@amd.com,
       linux-tip-commits@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 1/3] x86, msr: add rd/wrmsr interfaces with preset
 registers
Message-Id: <20090903161426.cc441294.akpm@linux-foundation.org>
In-Reply-To: <4AA049F2.5000403@zytor.com>
References: <20090831073429.GA26596@liondog.tnic>
	<1251705011-18636-1-git-send-email-petkovbb@gmail.com>
	<20090903155539.ecd64bcd.akpm@linux-foundation.org>
	<4AA049F2.5000403@zytor.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Sep 2009 15:57:54 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 09/03/2009 03:55 PM, Andrew Morton wrote:
> > On Mon, 31 Aug 2009 09:50:09 +0200
> > Borislav Petkov <petkovbb@googlemail.com> wrote:
> > 
> >> +.macro op_safe_regs op:req
> > 
> > Using
> > 
> > GNU assembler 2.16.1
> > 
> > I get
> > 
> > arch/x86/lib/msr-reg.S: Assembler messages:
> > arch/x86/lib/msr-reg.S:53: Error: Bad macro parameter list
> > arch/x86/lib/msr-reg.S:100: Error: invalid character '_' in mnemonic
> > arch/x86/lib/msr-reg.S:101: Error: invalid character '_' in mnemonic
> > 
> > this:
> > 
> > diff -puN arch/x86/lib/msr-reg.S~a arch/x86/lib/msr-reg.S
> > --- a/arch/x86/lib/msr-reg.S~a
> > +++ a/arch/x86/lib/msr-reg.S
> > @@ -50,7 +50,7 @@ ENDPROC(native_\op\()_safe_regs)
> >  
> >  #else /* X86_32 */
> >  
> > -.macro op_safe_regs op:req
> > +.macro op_safe_regs op
> >  ENTRY(native_\op\()_safe_regs)
> >         CFI_STARTPROC
> >         pushl_cfi %ebx
> > 
> > 
> > fixed it.
> 
> Yup, already fixed in -tip.
> 

<looks>

Three days ago.  linux-next is still busted.

I want my five minutes back.
