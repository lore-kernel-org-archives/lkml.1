Return-Path: <linux-kernel-owner+w=401wt.eu-S1761400AbYARCCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761400AbYARCCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 21:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760054AbYARCCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 21:02:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36804 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759153AbYARCCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 21:02:19 -0500
Message-ID: <4790074F.2020000@zytor.com>
Date: Thu, 17 Jan 2008 20:56:31 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86: unify pt_regs accessors ptrace.h
References: <1200621589.5724.92.camel@brick>
In-Reply-To: <1200621589.5724.92.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> Unify the definiton of:
> v8086_mode
> user_mode
> user_mode_vm
> stack_pointer
> instruction_pointer
> frame_pointer
> 
> in ptrace.h to make it clear where the differences are between
> 32 and 64 bit.  Changes macros to static inlines as well.
> 

Can you put a comment on stack_pointer() that it applies to a 
kernel-mode pt_regs only?

	-hpa
