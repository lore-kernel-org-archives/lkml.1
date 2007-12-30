Return-Path: <linux-kernel-owner+w=401wt.eu-S1756480AbXL3IeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480AbXL3IeI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 03:34:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbXL3Id5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 03:33:57 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbXL3Id4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 03:33:56 -0500
Message-ID: <4777574D.8010801@redhat.com>
Date: Sun, 30 Dec 2007 03:31:09 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Harvey Harrison <harvey.harrison@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: Introduce REX prefix helper for kprobes
References: <1198466795.6323.12.camel@brick> <47773C2D.8070600@redhat.com> <47774314.9080406@zytor.com> <47775062.4070300@redhat.com>
In-Reply-To: <47775062.4070300@redhat.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> (in case of CONFIG_X86_64)
> static inline int is_rex_prefix(int op)

Oops, s/int op/kprobe_opcode_t opcode/

> About the name, I just used the previous inline function name.

I re-think "is_REX_prefix" is better, because it is an architecture
dependent notation(intel's software developers manual called it
"REX prefixes"), and there is already is_IF_modifier() function
in arch/x86/kernel/kprobes.c.

Thanks,

Best Regards,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com

