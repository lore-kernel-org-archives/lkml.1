Return-Path: <linux-kernel-owner+w=401wt.eu-S1757557AbXLQOOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557AbXLQOOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 09:14:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbXLQOOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 09:14:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662AbXLQOOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 09:14:40 -0500
Message-ID: <4766841B.1040500@redhat.com>
Date: Mon, 17 Dec 2007 09:13:47 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Harvey Harrison <harvey.harrison@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Masami Hiramatsu <hiramatu@sdl.hitachi.co.jp>,
       Rusty Lynch <rusty.lynch@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Keshavamurthy Anil S <anil.s.keshavamurthy@intel.com>
Subject: Re: FInal kprobes rollup patches
References: <1197708350.898.87.camel@brick> <20071215085015.GA9720@elte.hu> <1197709442.898.97.camel@brick> <20071215131204.GE9720@elte.hu>
In-Reply-To: <20071215131204.GE9720@elte.hu>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harvey and Ingo,

I'm working on another version of patches for unification.
Currently cleaning up the patches.
http://sources.redhat.com/ml/systemtap/2007-q4/msg00457.html
I'll cleanup and repost it today.

Ingo Molnar wrote:
> * Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
>> If you compare this memcpy from arch_prepare_kprobe in 32/64 bit I'm 
>> almost sure the X86_32 version should be
>>
>> ... + sizeof(kprobe_opcode_t)
>>
>> not
>>
>> ... * sizeof(kprobe_opcode_t)
> 
> good point. I've Cc:-ed the top authors of kprobes.c. Could anyone 
> confirm (or deny) that Harvey found a real kprobes bug here?
> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com

