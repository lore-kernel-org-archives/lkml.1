Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbYHSBdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbYHSBdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 21:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbYHSBdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 21:33:36 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:53021 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbYHSBdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 21:33:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mQo6WAvNiLvwoa/pe9Oq/yYiJCv0yMjDE9x/2C8NL0rxFla2ruIjUGgYZ0Rl2+k8Ie
         wT4MG3o9/Qmrzp0mQGFzysOEQ3QpCXaYgEfKkQe2ZDLhonQQsip/a7xyLUV8R32FmQTS
         WsgB/DYlRvF7SYWd/sXXTHNca7gH9Y3Wo0gIc=
Message-ID: <86802c440808181833r4ab33653tbe331dc4ff5b8de8@mail.gmail.com>
Date: Mon, 18 Aug 2008 18:33:34 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 1/2] Xen: Fix bug `do_IRQ: cannot handle IRQ -1 vector 0x6 cpu 1'
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Alex Nixon" <alex.nixon@citrix.com>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080819011937.GD14821@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48A976E6.40906@citrix.com> <48A9EBBD.5010509@goop.org>
	 <20080819011937.GD14821@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 6:19 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>> Alex Nixon wrote:
>> > From: Alex Nixon <alex.nixon@citrix.com>
>> > Date: Mon, 18 Aug 2008 12:56:48 +0100
>> > Subject: [PATCH] Xen: Fix bug `do_IRQ: cannot handle IRQ -1 vector 0x6 cpu 1'
>> >
>> > Following commit 9c3f2468d8339866d9ef6a25aae31a8909c6be0d, do_IRQ() looks up the IRQ number in the per-cpu variable vector_irq.
>> >
>> > This commit makes Xen initialise an identity vector_irq map for both X86_32 and X86_64.
>> >
>>
>> Thanks Alex.
>>
>> Ingo, please apply.
>>
>> Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>
> i didnt get the original patches (they arent on lkml) - could you please
> resend them with your Acked-by line added as well?
>
> by the looks of it, both are needed for v2.6.27, agreed?
>

no,

only tip/irq/sparseirq make 32 bit support per_cpu vector.

YH
