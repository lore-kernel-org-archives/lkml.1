Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbZBINxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbZBINxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 08:53:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbZBINwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 08:52:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:33179 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452AbZBINwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:52:54 -0500
Message-ID: <4990350C.4010908@kernel.org>
Date: Mon, 09 Feb 2009 22:52:12 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: hpa@zytor.com, jeremy@goop.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, x86@kernel.org, rusty@rustcorp.com.au
Subject: Re: [PATCH 02/11] x86: math_emu info cleanup
References: <1234186798-16820-1-git-send-email-tj@kernel.org> <1234186798-16820-3-git-send-email-tj@kernel.org> <20090209134234.GA14048@elte.hu> <20090209134542.GA14785@elte.hu>
In-Reply-To: <20090209134542.GA14785@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 09 Feb 2009 13:52:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> * Tejun Heo <tj@kernel.org> wrote:
>>
>>> Impact: cleanup
>>>
>>> * Come on, struct info?  s/struct info/struct math_emu_info/
>>>
>>> * Use struct pt_regs and kernel_vm86_regs instead of defining its own
>>>   register frame structure.
>>>
>>> Signed-off-by: Tejun Heo <tj@kernel.org>
>>> ---
>>>  arch/x86/include/asm/math_emu.h  |   29 +++++------------
>>>  arch/x86/include/asm/processor.h |    2 +-
>>>  arch/x86/math-emu/fpu_entry.c    |    2 +-
>>>  arch/x86/math-emu/fpu_proto.h    |    2 +-
>>>  arch/x86/math-emu/fpu_system.h   |   14 ++++----
>>>  arch/x86/math-emu/get_address.c  |   63 ++++++++++++++++++--------------------
>>>  6 files changed, 48 insertions(+), 64 deletions(-)
>> Nice - that's a fix for .29 too, right?
> 
> this one i mean:
> 
> Subject: [PATCH 03/11] x86: fix math_emu register frame access

Yeap, 0001-0003 are candidates for .29 inclusion.

Thanks.

-- 
tejun
