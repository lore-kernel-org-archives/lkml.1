Return-Path: <linux-kernel-owner+w=401wt.eu-S1765417AbZAPNGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765417AbZAPNGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 08:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750942AbZAPNG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 08:06:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33462 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659AbZAPNG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 08:06:28 -0500
Date: Fri, 16 Jan 2009 14:06:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mandeep Singh Baines <msb@google.com>
Cc: hannes@cmpxchg.org, linux-kernel@vger.kernel.org, rientjes@google.com,
       mbligh@google.com, thockin@google.com
Subject: Re: [PATCH v4] softlockup: decouple hung tasks check from
	softlockup detection
Message-ID: <20090116130621.GK5421@elte.hu>
References: <20090114105426.GH2913@elte.hu> <20090115190840.GA1764@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090115190840.GA1764@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2521]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mandeep Singh Baines <msb@google.com> wrote:

> Ingo Molnar (mingo@elte.hu) wrote:
> > 
> > this now conflicts with the softlockup-panic fix you posted - and that fix 
> > has to go first as it's v2.6.29 material. (while the decoupling patch is 
> > 2.6.30 material)
> > 
> > So could you please send a patch against tip/master:
> > 
> >   http://people.redhat.com/mingo/tip.git/README
> > 
> > Thanks,
> > 
> >       Ingo
> 
> No problem. Rebased to tip/master.

applied to tip/core/softlockup - thanks Mandeep!

	Ingo
