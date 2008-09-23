Return-Path: <linux-kernel-owner+w=401wt.eu-S1752729AbYIWLsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbYIWLsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 07:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbYIWLso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 07:48:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56988 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbYIWLsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 07:48:43 -0400
Date: Tue, 23 Sep 2008 13:48:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: markus.t.metzger@gmail.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Roland McGrath <roland@redhat.com>,
       "linux-os (Dick Johnson)" <linux-os@analogic.com>
Subject: Re: [patch] x86, ptrace: void dopiness
Message-ID: <20080923114832.GF14840@elte.hu>
References: <20080919145250.A6000@sedona.ch.intel.com> <20080922115058.GB14301@elte.hu> <029E5BE7F699594398CA44E3DDF5544402781F00@swsmsx413.ger.corp.intel.com> <20080922120743.GF14301@elte.hu> <029E5BE7F699594398CA44E3DDF55444027827AD@swsmsx413.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <029E5BE7F699594398CA44E3DDF55444027827AD@swsmsx413.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Metzger, Markus T <markus.t.metzger@intel.com> wrote:

> >-----Original Message-----
> >From: Ingo Molnar [mailto:mingo@elte.hu] 
> >Sent: Montag, 22. September 2008 14:08
> >To: Metzger, Markus T
> 
> >> The void-cast is intentional in both cases.
> >> 
> >> I thought it a question of style, i.e. that we don't want void casts 
> >> just like we want NULL instead of 0.
> >
> >ok.
> >
> >But you could mark ds_release_bts() as a __must_check 
> >function, in that 
> >case the (void) has functional aspects as well: the kernel build will 
> >complain if a return value is ignored unintentionally.
> 
> Wouldn't every non-void function be __must_check?

no, only those which we mark so explicitly.

	Ingo
