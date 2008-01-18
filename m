Return-Path: <linux-kernel-owner+w=401wt.eu-S1760262AbYARCIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760262AbYARCIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 21:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756123AbYARCIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 21:08:11 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:52067 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbYARCIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 21:08:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TecD2Y2oev/99MdgfNhrNJdjAYbtp6ZzLIWr92X7Nlx7XitLL1dU49zb0PJFK1ZSozavGekf18ytiEEVE4ELxAc5/ffawPLM94CYNHiF+0n7ixVcp4yvoNHXiK8JfU/+5y07R/ojC9vvgFSEVPYEDm44XmQxHMDtFnaRqo2UOMI=
Subject: Re: [PATCH 1/2] x86: unify pt_regs accessors ptrace.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4790074F.2020000@zytor.com>
References: <1200621589.5724.92.camel@brick>  <4790074F.2020000@zytor.com>
Content-Type: text/plain
Date: Thu, 17 Jan 2008 18:08:09 -0800
Message-Id: <1200622089.5724.102.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-17 at 20:56 -0500, H. Peter Anvin wrote:
> Harvey Harrison wrote:
> > Unify the definiton of:
> > v8086_mode
> > user_mode
> > user_mode_vm
> > stack_pointer
> > instruction_pointer
> > frame_pointer
> > 
> > in ptrace.h to make it clear where the differences are between
> > 32 and 64 bit.  Changes macros to static inlines as well.
> > 
> 
> Can you put a comment on stack_pointer() that it applies to a 
> kernel-mode pt_regs only?

How about a follow-on patch that picks a better name and adds the
comment?  I'd like to leave this as a movement-only patch.  Once we
decide on a name I'll do the rename/comment.  It seems like there are
very few users currently (oprofile/backtrace.c only?).

Then I'll also change the kprobes code to use this instead of their
stack_addr helper.

Harvey

