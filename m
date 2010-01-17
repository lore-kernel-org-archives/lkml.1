Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170Ab0AQASS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab0AQASS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 19:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100Ab0AQASP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 19:18:15 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:48560 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab0AQASO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 19:18:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=l6pg1do1D9MxTg3AcKVjVd0g4qalZO3S2YN0R7hR6nc3f7SgoJOAhX8L0SrivSfpyc
         W1xpiiM9qu5+VsVSk9ortPbDfsDyv0JouFenmZ3CCgIF6U1W1HKACOa7atflJJVoqogL
         mAv/xNviTkPQ/F78D5043NbFyHvMS4Xm2AOfU=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1001161233300.13231@localhost.localdomain>
References: <20100116170338.GA17175@elte.hu>
	 <alpine.LFD.2.00.1001161233300.13231@localhost.localdomain>
Date: Sat, 16 Jan 2010 19:18:12 -0500
Message-ID: <73c1f2161001161618l7b471f48ldb4c33c88eafb7b6@mail.gmail.com>
Subject: Re: [GIT PULL] x86 fixes
From: Brian Gerst <brgerst@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 16, 2010 at 3:34 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Sat, 16 Jan 2010, Ingo Molnar wrote:
>>
>> Cyrill Gorcunov (1):
>>       x86: kernel_thread() -- initialize SS to a known state
>
> This looks bogus. Why does it do it only on x86-64?
>
> Either people care about SS or they don't (the answer, I suspect, is "they
> don't"). But if they care, we should do it on both 32-bit _and_ 64-bit,
> no?

32-bit doesn't care about ss or esp since it won't pop them from the
stack when returning to the same privilege level.

--
Brian Gerst
