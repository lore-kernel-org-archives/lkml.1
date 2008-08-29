Return-Path: <linux-kernel-owner+w=401wt.eu-S1758942AbYH2Vny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942AbYH2Vny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 17:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754705AbYH2Vnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 17:43:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:15594 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbYH2Vnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 17:43:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uFsMT7tf29P2za9WWvWyEHXjd1n4t3v+j0KUN9UH2zFMnBtl+nXcjgVx86dDZvuVwg
         fyGGh/LeXppsgH2FCA/APuesnWXPZY+t/JYuM3C3z+qyFoZu97or+FYqKeI9kDLblDOd
         ItE0CJpFnTnyeINslPlw8pDfWJoI+3VQpkb/o=
Message-ID: <86802c440808291443y121c422blaa24d543e67d0de2@mail.gmail.com>
Date: Fri, 29 Aug 2008 14:43:45 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/53] dyn_array/nr_irqs/sparse_irq support v10
Cc: "Ingo Molnar" <mingo@elte.hu>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       ebiederm@xmission.com
In-Reply-To: <20080829141642.c0f266f3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218705441-21838-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080814132638.GA18743@elte.hu>
	 <20080829141642.c0f266f3.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 2:16 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 14 Aug 2008 15:26:38 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
>
>> ok, i've created a new tip/irq/sparseirq topic branch for this.
>
> This:
>
> init/dyn_array.c: In function 'pre_alloc_dyn_array':
> init/dyn_array.c:21: warning: 'print_fn_descriptor_symbol' is deprecated (declared at include/linux/kallsyms.h:100)
> init/dyn_array.c:45: warning: 'print_fn_descriptor_symbol' is deprecated (declared at include/linux/kallsyms.h:100)
> init/dyn_array.c: In function 'per_cpu_dyn_array_size':
> init/dyn_array.c:78: warning: 'print_fn_descriptor_symbol' is deprecated (declared at include/linux/kallsyms.h:100)
> init/dyn_array.c: In function 'per_cpu_alloc_dyn_array':
> init/dyn_array.c:107: warning: 'print_fn_descriptor_symbol' is deprecated (declared at include/linux/kallsyms.h:100)
>
> is reminding us about %pS/%pF.

in init/main.c::do_one_initcall() is still using it...

also i didn't get this warning, what is your gcc version?

YH
