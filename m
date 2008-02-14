Return-Path: <linux-kernel-owner+w=401wt.eu-S1756895AbYBNPIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbYBNPIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:08:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbYBNPId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:08:33 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbYBNPIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:08:32 -0500
Message-ID: <47B4595D.6030900@redhat.com>
Date: Thu, 14 Feb 2008 10:08:13 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kprobes: remove sparse warnings from x86
References: <1202945433.18204.28.camel@brick>
In-Reply-To: <1202945433.18204.28.camel@brick>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison :
> arch/x86/kernel/kprobes.c:584:16: warning: symbol 'kretprobe_trampoline_holder' was not declared. Should it be static?
> arch/x86/kernel/kprobes.c:676:6: warning: symbol 'trampoline_handler' was not declared. Should it be static?
> 
> Make them static and add the __used attribute, approach taken from the
> arm kprobes implementation.
> 
> kretprobe_trampoline_holder uses inline assemly to define the global
> symbol kretprobe_trampoline, but nothing ever calls the holder explicitly.
> 
> trampoline handler is only called from inline assembly in the same file,
> mark it used and static.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

It looks good to me.

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

