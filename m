Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab0CGJ4a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 04:56:30 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:51410 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab0CGJ42 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 04:56:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rHC+R6t9axNyQ3BFcRkkUVH0ZywOafa2E6D33AhbykHIxu4z27cz1aSRGLBQgRJ/5N
         dTvQaU8dLW12V2E2k9Aqnoosb+lUCAHznxIu9F9bvClbnI5UFPHAeUaFsJs+tVI6Q4C0
         jmcKtEzN/FjeAFaVlsT/eCwjWUv/Q+J88I6RE=
MIME-Version: 1.0
In-Reply-To: <4B937363.4070406@redhat.com>
References: <4B87A6BF.3090301@redhat.com> <20100227105643.GA17425@elte.hu>
	 <4B893B2B.40301@redhat.com> <20100227172546.GA31472@elte.hu>
	 <4B8BEFC7.2040000@redhat.com>
	 <20100301174106.GB2362@ghostprotocols.net>
	 <4B8C0778.8050908@redhat.com> <20100301205620.GA26151@elte.hu>
	 <20100302103045.GA28310@elte.hu> <4B937363.4070406@redhat.com>
Date: Sun, 7 Mar 2010 11:56:26 +0200
X-Google-Sender-Auth: 4714dfeeb6847782
Message-ID: <84144f021003070156p2e0e86fche27c2b8d7d3e760@mail.gmail.com>
Subject: Re: KVM usability
From: Pekka Enberg <penberg@cs.helsinki.fi>
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

Hi Avi,

(slightly off-topic)

On Sun, Mar 7, 2010 at 11:35 AM, Avi Kivity <avi@redhat.com> wrote:
> perf really is wonderful, but to be really competitive, and usable to more
> developers, it needs to be in a graphical environment.  I want 'perf report'
> output to start out collapsed and drill down by clicking on a tree widget.
>  Clicking on a function name opens its definition.  'perf annotate' should
> display annotations on my editor window, not in a pager.  I should be able
> to check events on a list, not using 'perf list'.

People keep bringing this up but I don't quite agree. Mac OS X has
"shark" which is pretty much what you describe above. However, having
used both, I prefer perf's simple UI for two reasons: it's much easier
to automate perf commands and text-based reports are superior for
sharing results (and keeping track of results when doing performance
optimizations).

That said, AFAICT, it should be pretty simple to implement a
shark-like UI with GTK as current perf code is pretty good fit for
that. I've pondered about doing that myself but quite frankly, I don't
see any big gains in that.

                        Pekka
