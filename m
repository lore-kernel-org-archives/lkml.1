Return-Path: <linux-kernel-owner+w=401wt.eu-S1760975AbZLJQYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760975AbZLJQYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 11:24:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758514AbZLJQYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 11:24:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46513 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757081AbZLJQYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 11:24:51 -0500
Date: Thu, 10 Dec 2009 17:24:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matt Mackall <mpm@selenic.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: upstream regression: slob hang
Message-ID: <20091210162451.GA7761@elte.hu>
References: <20091210084949.GA18015@elte.hu>
 <1260462133.24459.1006.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260462133.24459.1006.camel@calx>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Mackall <mpm@selenic.com> wrote:

> On Thu, 2009-12-10 at 09:49 +0100, Ingo Molnar wrote:
>
> > FYI, the attached config hangs in the SLOB code, on 32-bit x86 
> > laptop (dual core). No log available from that box.
> 
> Is this one of your randconfigs? [...]

Yeah, a bootable one.

> [...] I take it switching from SLOB to SLUB fixes it?

havent tried it. If you cannot reproduce it with the config i sent i can 
try to dig deeper. That box is not particularly easy to debug.

	Ingo
