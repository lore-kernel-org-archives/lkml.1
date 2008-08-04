Return-Path: <linux-kernel-owner+w=401wt.eu-S1758097AbYHDOcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097AbYHDOcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 10:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755817AbYHDOcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 10:32:00 -0400
Received: from relay2.sgi.com ([192.48.171.30]:44716 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755698AbYHDOb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 10:31:59 -0400
Message-ID: <489712DB.80502@sgi.com>
Date: Mon, 04 Aug 2008 07:31:55 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/25] dyn_array and nr_irqs support v3
References: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>	<m1fxpm8x3n.fsf@frodo.ebiederm.org>	<86802c440808022304g41749d9dn7688c81c3fdbed8a@mail.gmail.com> <m18wve7gbt.fsf@frodo.ebiederm.org>
In-Reply-To: <m18wve7gbt.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
> 
>> On Sat, Aug 2, 2008 at 10:51 PM, Eric W. Biederman
>> <ebiederm@xmission.com> wrote:
>>> It appears that quite a few of the places you have changed are testing
>>> to see if an irq is valid.  The idiomatic way to perform that test in
>>> the kernel is:
>>>
>>> if (irq)
>> is uninitialized irq to be -1 or 0?
> 
> 0.  There is a long history behind it, but by decree of Linus and to conform
> with reasonable intuition 0 is not a valid irq except in certain arch specific
> corner cases.
> 
>>> With no test to see if you are >= NR_IRQS.
>>>
>>> I expect that is the change we want in the drivers that are performing such a
>> silly
>>> extra check.
>> is_irq_valid(irq_no) ?
>>
>> wait to see your new patchset about dyn irq_cfg and irq_desc
> 
> I haven't promised one, at least not lately.  I went down a couple of
> blind alleys and figured out what needed to be accomplished and then
> ran out of steam about a year and a half 2 years ago, and I haven't
> been able to get back to it.
> 
> Eric

I've put this on my queue of "items to examine more closely".  Priority-wise,
it's not quite at the front yet.

Thanks,
Mike
