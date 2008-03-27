Return-Path: <linux-kernel-owner+w=401wt.eu-S1758188AbYC0J6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188AbYC0J6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 05:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbYC0J60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 05:58:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40423 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbYC0J6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 05:58:25 -0400
Date: Thu, 27 Mar 2008 10:58:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: ak@suse.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, markus.t.metzger@gmail.com,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, roland@redhat.com,
       akpm@linux-foundation.org, mtk.manpages@gmail.com,
       eranian@googlemail.com, "Villacis, Juan" <juan.villacis@intel.com>
Subject: Re: [patch] x86, ptrace: support pebs in ds.c and disable
	ptraceand ds support
Message-ID: <20080327095803.GB15003@elte.hu>
References: <20080312125318.A15510@sedona.ch.intel.com> <20080321125338.GB27245@elte.hu> <029E5BE7F699594398CA44E3DDF55444019B5025@swsmsx413.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <029E5BE7F699594398CA44E3DDF55444019B5025@swsmsx413.ger.corp.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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

> > we could apply this if Roland Acks it - but i guess a precondition 
> > for that is to not include more ptrace extensions and to also start 
> > working on utrace support for it. Ptrace is something we want to 
> > reduce usage of, not extend.
> 
> The patch is not adding new features. It is merely re-establishing the 
> state before the patch mysteriously disappeared from x86#testing.

well, Roland is the de-facto ptrace maintainer and he has NAK-ed the 
current approach of extending ptrace, so i removed the patch. Is there 
anything particularly wrong about doing this based on utrace? The API 
will hit upstream in 2.6.26 or 2.6.27.

	Ingo
