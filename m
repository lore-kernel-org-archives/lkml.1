Return-Path: <linux-kernel-owner+w=401wt.eu-S1758967AbYH2Vti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967AbYH2Vti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 17:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbYH2Vta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 17:49:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54494 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751207AbYH2Vt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 17:49:29 -0400
Date: Fri, 29 Aug 2008 14:49:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       ebiederm@xmission.com
Subject: Re: [PATCH 00/53] dyn_array/nr_irqs/sparse_irq support v10
Message-Id: <20080829144900.5420efc3.akpm@linux-foundation.org>
In-Reply-To: <86802c440808291443y121c422blaa24d543e67d0de2@mail.gmail.com>
References: <1218705441-21838-1-git-send-email-yhlu.kernel@gmail.com>
	<20080814132638.GA18743@elte.hu>
	<20080829141642.c0f266f3.akpm@linux-foundation.org>
	<86802c440808291443y121c422blaa24d543e67d0de2@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008 14:43:45 -0700
"Yinghai Lu" <yhlu.kernel@gmail.com> wrote:

> On Fri, Aug 29, 2008 at 2:16 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Thu, 14 Aug 2008 15:26:38 +0200
> > Ingo Molnar <mingo@elte.hu> wrote:
> >
> >> ok, i've created a new tip/irq/sparseirq topic branch for this.
> >
> > This:
> >
> > init/dyn_array.c: In function 'pre_alloc_dyn_array':
> > init/dyn_array.c:21: warning: 'print_fn_descriptor_symbol' is deprecated (declared at include/linux/kallsyms.h:100)
> > init/dyn_array.c:45: warning: 'print_fn_descriptor_symbol' is deprecated (declared at include/linux/kallsyms.h:100)
> > init/dyn_array.c: In function 'per_cpu_dyn_array_size':
> > init/dyn_array.c:78: warning: 'print_fn_descriptor_symbol' is deprecated (declared at include/linux/kallsyms.h:100)
> > init/dyn_array.c: In function 'per_cpu_alloc_dyn_array':
> > init/dyn_array.c:107: warning: 'print_fn_descriptor_symbol' is deprecated (declared at include/linux/kallsyms.h:100)
> >
> > is reminding us about %pS/%pF.
> 
> in init/main.c::do_one_initcall() is still using it...

So?

That got converted in -mm.

> also i didn't get this warning, what is your gcc version?

See http://userweb.kernel.org/~akpm/mmotm/broken-out/vsprintf-use-new-vsprintf-symbolic-function-pointer-format.patch
