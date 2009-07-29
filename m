Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717AbZG2MnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbZG2MnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 08:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbZG2MnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 08:43:16 -0400
Received: from viefep18-int.chello.at ([62.179.121.38]:27447 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511AbZG2MnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 08:43:15 -0400
X-SourceIP: 213.93.53.227
Subject: Re: perf_counters issue with self-sampling threads
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: eranian@gmail.com
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>,
       Michael Kerrisk <mtk.manpages@googlemail.com>, oleg <oleg@redhat.com>
In-Reply-To: <7c86c4470907290537q42195dc6s61d0f6d4a3a70154@mail.gmail.com>
References: <7c86c4470907270951i48886d56g90bc198f26bb0716@mail.gmail.com>
	 <1248869948.6987.3083.camel@twins>
	 <7c86c4470907290537q42195dc6s61d0f6d4a3a70154@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 14:46:05 +0200
Message-Id: <1248871565.6987.3087.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-29 at 14:37 +0200, stephane eranian wrote:
> 
> >
> > Now I was considering teaching send_sigio_to_task() to use
> > specific_send_sig_info() when fown->pid != fown->group_leader->pid or
> > something, but I'm not sure that won't break anything.
> >
> Yes, that's the problem with touching this. I don't know if this will break
> things. That's why I was suggested creating a parallel code path which
> does what we want without modifying the existing path. Unless you know
> some signal expert at redhat or elsewhere.

His name is Oleg, and he's on CC ;-)

> > Alternatively, I've missed a detail and I either read the manpage wrong,
> > or the code, or both of them.
> >
> The code does not correspond to the manpage. Not clear which one
> is correct though. This F_SETOWN trick looks very Linux specific.

Linus specific sounds good enough to me. Michael might have something so
say on this though...

