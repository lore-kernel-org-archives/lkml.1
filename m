Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbYAJLIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbYAJLIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 06:08:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752820AbYAJLIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 06:08:31 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778AbYAJLIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 06:08:30 -0500
Message-ID: <4785FC4A.2010108@redhat.com>
Date: Thu, 10 Jan 2008 06:06:50 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [PATCH] x86: trivial whitespace in kprobes.c
References: <1199954157.19760.22.camel@brick> <4785F6A1.5020202@redhat.com>
In-Reply-To: <4785F6A1.5020202@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> Harvey Harrison wrote:
>> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> 
> Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
> 
>> ---
>> Ingo, you could/should probably fold this into Masami's kprobe
>> unification patch.
> 
> The original code had these whitespace, because (I think)
> kretprobe_trampoline_holder() had just hold a memory space
> for hooking function return. And now, it has actual code.

Hmm, this function still a bit special, because it is not
called directly. kretprobe uses kretprobe_trampoline symbol,
which is defined in this function.
Anyway, I think the whitespace does not help us understand it...

> So the whitespace can be removed.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com

