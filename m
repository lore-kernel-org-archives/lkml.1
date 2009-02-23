Return-Path: <linux-kernel-owner+w=401wt.eu-S1753653AbZBWQVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbZBWQVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 11:21:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754653AbZBWQVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 11:21:20 -0500
Received: from mx2.redhat.com ([66.187.237.31]:54927 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188AbZBWQVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 11:21:18 -0500
Message-ID: <49A2CD1E.60606@redhat.com>
Date: Mon, 23 Feb 2009 11:21:50 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
       systemtap-ml <systemtap@sources.redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [tip:x86/mm] x86, mm, kprobes: fault.c, simplify	notify_page_fault()
References: <tip-b18018126f422f5b706fd750373425e10e84b486@kernel.org> <499F383B.6060700@redhat.com> <20090222093109.GE6964@elte.hu>
In-Reply-To: <20090222093109.GE6964@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Ingo Molnar wrote:
> another very small thing, while we are discussing kprobes:
> 
> I always found that the __kprobes annotation is very confusingly 
> euphemistic: what those annotations really mean is not 
> 'kprobes', but 'no kprobes'.

As far as I know, __kprobes originally means 'this function will be
called from kprobes'. However, now many functions are tagged as
__kprobes, it might be confusingly.

> So how about renaming __kprobes to __nokprobes, similar to how 
> we have the notrace attribute?

Would you mean that will include changing section name of
'.text.kprobes'? That's what I mind.

> We have about 350 __kprobes annotations in the kernel, so 
> renaming it now would not be practical - but any objections 
> against me sending Linus a rename patch somewhere late in the 
> next merge window that just does this rename?

Just renaming __kprobes to __nokprobes seems good for me.

Thank you!


> [ likewise, i'll rename notrace to __notrace to make it visually 
>   less intrusive to the return value type. There's a lot less 
>   such annotations in the kernel. ]
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

e-mail: mhiramat@redhat.com

