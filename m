Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab0CGPOw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 10:14:52 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:33528 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab0CGPOv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 10:14:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Tknb3bnvDraCvfb3JiAm724Favy3CYG5jsluedTy4OPT0p9pQUGz2wSDbjOHmkPUpu
         EsheSoVQQvhweVipnVX1yluDvoVj2R15rA+n2iXoY9pPKwu+a1FC0lxF2GXdvBeCQJL+
         YuhbMpS1dew4mfn+oi2OubQmUgpgIQ45x/Ss0=
MIME-Version: 1.0
In-Reply-To: <4B937363.4070406@redhat.com>
References: <4B87A6BF.3090301@redhat.com> <20100227105643.GA17425@elte.hu>
	 <4B893B2B.40301@redhat.com> <20100227172546.GA31472@elte.hu>
	 <4B8BEFC7.2040000@redhat.com>
	 <20100301174106.GB2362@ghostprotocols.net>
	 <4B8C0778.8050908@redhat.com> <20100301205620.GA26151@elte.hu>
	 <20100302103045.GA28310@elte.hu> <4B937363.4070406@redhat.com>
Date: Sun, 7 Mar 2010 16:14:49 +0100
Message-ID: <ff13bc9a1003070714q3963a302ne37a57537423da57@mail.gmail.com>
Subject: Re: KVM usability
From: Luca Barbieri <luca.barbieri@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Zachary Amsden <zamsden@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>, ming.m.lin@intel.com,
       sheng.yang@intel.com, Jes Sorensen <Jes.Sorensen@redhat.com>,
       KVM General <kvm@vger.kernel.org>, Gleb Natapov <gleb@redhat.com>,
       "Fr??d??ric Weisbecker" <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> perf really is wonderful, but to be really competitive, and usable to more
> developers, it needs to be in a graphical environment.  I want 'perf report'
> output to start out collapsed and drill down by clicking on a tree widget.
>  Clicking on a function name opens its definition.  'perf annotate' should
> display annotations on my editor window, not in a pager.  I should be able
> to check events on a list, not using 'perf list'.
>
> Is something like that suitable for tools/perf/?  I think you'll find the
> intersection of kernel developers and GUI developers to be fairly small.

The latest versions of Gnome Sysprof use perf and provide a GTK+ tree
interface for the profiling output.

However, they are not configurable at all and don't support anything
but call graph profiling, unless they added more features very
recently.
It would be nice to extend sysprof into a more capable tool, and one
that can read perf output files and do so when launched from the
command line.
