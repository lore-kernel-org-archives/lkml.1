Return-Path: <linux-kernel-owner+w=401wt.eu-S1760272AbYARCLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760272AbYARCLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 21:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756719AbYARCLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 21:11:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54886 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbYARCLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 21:11:33 -0500
Message-ID: <47900978.90107@zytor.com>
Date: Thu, 17 Jan 2008 21:05:44 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86: unify pt_regs accessors ptrace.h
References: <1200621589.5724.92.camel@brick>  <4790074F.2020000@zytor.com> <1200622089.5724.102.camel@brick>
In-Reply-To: <1200622089.5724.102.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> On Thu, 2008-01-17 at 20:56 -0500, H. Peter Anvin wrote:
>> Harvey Harrison wrote:
>>> Unify the definiton of:
>>> v8086_mode
>>> user_mode
>>> user_mode_vm
>>> stack_pointer
>>> instruction_pointer
>>> frame_pointer
>>>
>>> in ptrace.h to make it clear where the differences are between
>>> 32 and 64 bit.  Changes macros to static inlines as well.
>>>
>> Can you put a comment on stack_pointer() that it applies to a 
>> kernel-mode pt_regs only?
> 
> How about a follow-on patch that picks a better name and adds the
> comment?  I'd like to leave this as a movement-only patch.  Once we
> decide on a name I'll do the rename/comment.  It seems like there are
> very few users currently (oprofile/backtrace.c only?).
> 
> Then I'll also change the kprobes code to use this instead of their
> stack_addr helper.
> 

IMO, go ahead and add a comment, but yes, renaming should be a separate 
patch.

	-hpa
