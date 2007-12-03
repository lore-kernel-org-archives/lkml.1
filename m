Return-Path: <linux-kernel-owner+w=401wt.eu-S1753044AbXLCQVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044AbXLCQVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 11:21:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbXLCQVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 11:21:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:53649 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbXLCQVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 11:21:44 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Markus Metzger" <markus.t.metzger@googlemail.com>
Subject: Re: [patch 0/2] x86, ptrace: support for branch trace store(BTS)
Date: Mon, 3 Dec 2007 17:21:38 +0100
User-Agent: KMail/1.9.6
Cc: "Roland McGrath" <roland@redhat.com>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>, tglx@linutronix.de,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Michael Kerrisk" <mtk-manpages@gmx.net>, markus.t.metzger@gmail.com,
       "Ingo Molnar" <mingo@elte.hu>
References: <029E5BE7F699594398CA44E3DDF5544401024075@swsmsx413.ger.corp.intel.com> <20071201074044.GA13974@elte.hu> <a430082a0712030553v22e9b46bnb9da975a23b1c0db@mail.gmail.com>
In-Reply-To: <a430082a0712030553v22e9b46bnb9da975a23b1c0db@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712031721.39013.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 December 2007 14:53:27 Markus Metzger wrote:
> > Cool.  It's been on my list to look into exposing those features
> > somehow. I hadn't planned on doing it until after the utrace stuff
> > settles and there is a more coherent interface context in which to do
> > it.
> 
> I'm looking very much forward to utrace. From what I read so far, this is
> a much nicer interface.

Just don't wait for that. utrace doesn't seem to have any concrete 
plans to merge any time soon AFAIK[1] and it would be a shame to delay an useful
feature forever.

[1] At least the patches have not reached any mailing lists

> What did you have in mind when you asked for kernel-mode support?

I asked about that earlier too and I would like to see per CPU traces
for ring 0 with some way to dump that on crashes or on user trigger.

-Andi

