Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbYHKQ5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbYHKQ5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 12:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbYHKQ5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 12:57:16 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:18823 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbYHKQ5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 12:57:15 -0400
To: "Jaswinder Singh" <jaswinderdavinci@gmail.com>
Cc: "Sudhakar Rajashekhara" <sudhakar.raj@ti.com>,
       davinci-linux-open-source@linux.davincidsp.com,
       linux-kernel@vger.kernel.org, lethal@linux-sh.org
Subject: Re: [PATCH v2 02/13] ARM:DaVinci: base address for dm6467
References: <1218098155-11999-1-git-send-email-sudhakar.raj@ti.com>
	<87proke7gf.fsf@deeprootsystems.com>
	<95c340a40808100234u14bb1c23x7941c2a7ead1eb7@mail.gmail.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Mon, 11 Aug 2008 09:57:07 -0700
In-Reply-To: <95c340a40808100234u14bb1c23x7941c2a7ead1eb7@mail.gmail.com> (Jaswinder Singh's message of "Sun\, 10 Aug 2008 15\:04\:36 +0530")
Message-ID: <87d4kffq1o.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Jaswinder Singh" <jaswinderdavinci@gmail.com> writes:

> Hello all,
>
> On Fri, Aug 8, 2008 at 4:52 AM, Kevin Hilman
> <khilman@deeprootsystems.com> wrote:
>> Sudhakar Rajashekhara <sudhakar.raj@ti.com> writes:
>>
>>> Source: Texas Instruments Inc.
>>> Type: Enhancement
>>> Signed-off-by: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
>>> Description:
>>> Defines the base addresses and LPSC assignments for dm6467.
>>> ---
>>>  include/asm-arm/arch-davinci/hardware.h        |    2 +
>>>  include/asm-arm/arch-davinci/hardware_dm6467.h |   90 ++++++++++++++++++++++++
>>>  2 files changed, 92 insertions(+), 0 deletions(-)
>>>  create mode 100644 include/asm-arm/arch-davinci/hardware_dm6467.h
>>>
>>> diff --git a/include/asm-arm/arch-davinci/hardware.h b/include/asm-arm/arch-davinci/hardware.h
>>> index a2e8969..1f88572 100644
>>> --- a/include/asm-arm/arch-davinci/hardware.h
>>> +++ b/include/asm-arm/arch-davinci/hardware.h
>>> @@ -11,6 +11,8 @@
>>>  #ifndef __ASM_ARCH_HARDWARE_H
>>>  #define __ASM_ARCH_HARDWARE_H
>>>
>>> +#include <asm/arch/hardware_dm6467.h>
>>> +
>>
>> Yes, Like that this is a separate file.  However, lets just call it dm6467.h
>>
>
> I do not understand what is the point of adding dm6467.h without
> #ifdef CONFIG_ARCH_DAVINCI_DM646x. If I have 6446 why should I add
> 6467. This make sense if I have board with multiple chips like dm6446
> chip and dm6467 chips. Can you please explain.
>
> I can understand you are trying to follow omap model but some other
> nice models are also available for example SH model we can take
> advantage of those.
>
> I like this approach in SH that they are growing in multiple-direction
> as they added supports for cpus, boards and drivers. They did their
> porting in such a way that it is easy to add more boards and more cpus
> by just copying paste and change your settings as per your hardware.
>
> Currently we are assuming 6446 chip as common. I think 6446 part
> should also come in ifdef  CONFIG_ARCH_DAVINCI_DM646x. If I am using
> DM355 why should I need 6446.
>
> And Currently arch-davinci is based only on TI EVM board. There are
> different kinds of boards available in market. To add them in linux
> tree we should move current EVM to CONFIG_MACH_DAVINCI_TIEVM. So I
> think we also need to revise our directory sturcture to grow our
> family.

We're not assuming a 6446/EVM is common or the reference.  It's just
that this is the only one that exists currently in git.  It does not
mean that new stuff hast to follow what is done for 6446.  Now is the
time to re-organize things so that it can expand as more parts are
added.  Patches welcome.

Kevin



