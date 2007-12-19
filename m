Return-Path: <linux-kernel-owner+w=401wt.eu-S1753971AbXLSQF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbXLSQF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 11:05:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbXLSQFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 11:05:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbXLSQFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 11:05:17 -0500
Message-ID: <476940D0.30106@redhat.com>
Date: Wed, 19 Dec 2007 11:03:28 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Roland McGrath <roland@redhat.com>,
       prasanna@in.ibm.com, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net, Harvey Harrison <harvey.harrison@gmail.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/2] x86: fix kprobe_handler reenable preemption
References: <4768555A.3000604@redhat.com> <476890CC.1020100@redhat.com> <20071219102007.GE3521@elte.hu>
In-Reply-To: <20071219102007.GE3521@elte.hu>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Ingo Molnar wrote:
> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
>>> -			return 1;
>>> +			ret = 1;
>> Here, "return 1;" is correct. After single step is done, preemption is 
>> enabled in post_kprobe_handler().
> 
> could you resend the fixed patch? (instead of me fixing it up by hand - 
> which is error-prone)

Sure, I'll resend asap.

> 
> also, this seems like .24 material as well - could you send the fix 
> against -rc5 too?

-rc tree is fine. Actually, it was introduced by my cleanup patch.
Thanks!

> 
> 	Ingo

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com


