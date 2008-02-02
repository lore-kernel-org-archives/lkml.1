Return-Path: <linux-kernel-owner+w=401wt.eu-S1765479AbYBBI1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765479AbYBBI1w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 03:27:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757395AbYBBI1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 03:27:45 -0500
Received: from qb-out-0506.google.com ([72.14.204.231]:62999 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756866AbYBBI1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 03:27:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PC1YA4t/pPHjUt/TpbaOyXEBYMXeGEGApJiLQEdJMlW7zvSUF+AeMA15zKTT6wX0/r8Kfsu69tVsa9S7dUxRqv7xMvI49EiKNqgsHkgNbda65d8Fu2vmdnsj79ZcWHLY4jyqAFJU4op+F5qQ71pIH/L4I0jpRZZ0CjDZ4wPAtyw=
Subject: Re: [PATCH 2/3] x86: add function prototype to vm86.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47A42662.6090702@cn.fujitsu.com>
References: <1201938485.1844.6.camel@brick>
	 <47A42662.6090702@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Date: Sat, 02 Feb 2008 00:27:49 -0800
Message-Id: <1201940869.1844.14.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-02-02 at 16:14 +0800, Li Zefan wrote:
> Harvey Harrison 写道:
> > Global functions should include their prototypes.
> > 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > ---
> >  include/asm-x86/vm86.h |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/asm-x86/vm86.h b/include/asm-x86/vm86.h
> > index a5edf51..b72b9a6 100644
> > --- a/include/asm-x86/vm86.h
> > +++ b/include/asm-x86/vm86.h
> > @@ -195,6 +195,7 @@ struct kernel_vm86_struct {
> >  
> >  void handle_vm86_fault(struct kernel_vm86_regs *, long);
> >  int handle_vm86_trap(struct kernel_vm86_regs *, long, int);
> > +struct pt_regs * save_v86_state(struct kernel_vm86_regs *);
> >  
> 
> This fixes a sparse warning, but contribute to a coding style error.
> checkpatch.pl complains about this patch.

Bugger, thought I caught that.  Hopefully Ingo will delete the extra
space when applying, otherwise I'll send a replacement.

My apologies,

Harvey


