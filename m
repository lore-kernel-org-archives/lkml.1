Return-Path: <linux-kernel-owner+w=401wt.eu-S1755183AbXL3RkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbXL3RkT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 12:40:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750945AbXL3RkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 12:40:07 -0500
Received: from an-out-0708.google.com ([209.85.132.250]:61574 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbXL3RkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 12:40:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BxSIIS1b9kxy6Rm8Dus1LK/O6/MROcugWUFxgLnlq0jZREe7OWKURK3c7UiMHV5OG7OzKzqcPGSl4f6pWKMIcQy9lTfO6HrHHS1sEQjlykJkY8L+r5xylbVwvVJhfsMSLdI1X6+b8D42bllibOITDNBIDPR3F1d5ePKK5oa+C/Y=
Subject: Re: [PATCH] x86: Introduce REX prefix helper for kprobes
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <47774314.9080406@zytor.com>
References: <1198466795.6323.12.camel@brick> <47773C2D.8070600@redhat.com>
	 <47774314.9080406@zytor.com>
Content-Type: text/plain
Date: Sun, 30 Dec 2007 09:39:55 -0800
Message-Id: <1199036395.6323.41.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-12-29 at 23:04 -0800, H. Peter Anvin wrote:
> Masami Hiramatsu wrote:
> > Hi Harvey,
> > 
> > Harvey Harrison wrote:
> >> Fold some small ifdefs into a helper function.
> >>
> >> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> >> ---
> >> Masami, Ingo, I had this left in some unsent kprobes unification
> >> work.  Depends on your tastes, but does reduce ifdefs and is a bit
> >> better about self-documenting the REX prefix on X86_64.
> > 
> > Basically, I think it is good idea.
> > Could you use a macro same as the stack_addr() macro, like as below?
> > 
> > #defile is_REX_prefix(insn) ((insn & 0xf0) == 0x40))
> > 
> > This is just a bit checker, so I think a macro is better to do that.
> > 
> 
> Why is a macro better than an inline, and why the odd mIXed case?
> 

I was emulating existing practice I saw in kprobes, see is_IF_modifier.

Harvey

