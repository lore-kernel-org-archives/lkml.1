Return-Path: <linux-kernel-owner+w=401wt.eu-S1756285AbYBIJeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285AbYBIJeQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 04:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbYBIJeC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 04:34:02 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36240 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218AbYBIJeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 04:34:00 -0500
Date: Sat, 9 Feb 2008 10:33:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Richard Knutsson <ricknu-0@student.ltu.se>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 1/2] kmemcheck v3
Message-ID: <20080209093343.GA23004@elte.hu>
References: <47AB79D4.2070605@gmail.com> <20080208115542.GD4745@one.firstfloor.org> <19f34abd0802080418o75969480v3286da7a83ebc178@mail.gmail.com> <20080208132032.GA6115@one.firstfloor.org> <19f34abd0802080459t4630c251q2a7cb3680e207e7a@mail.gmail.com> <20080208134823.GB6115@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080208134823.GB6115@one.firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> > Yes, this is true. Then our task is to make sure that this memory is 
> > never allocated from tracked caches. We do have some changes in this 
> > area, for instance we never track task structs. Keep in mind that 
> > only slab objects are tracked currently, so things like stacks never 
> > catch page faults. I am not sure if this is exactly what you had in 
> > mind, but I don't know other kernel code very well enough to come up 
> > with perhaps more relevant examples :-)
> 
> Given that you don't seem to handle networking yet I wonder how many 
> cases you really tested so far.

you are wrong about no networking support: i have booted up a full 
distro config on real hardware with full networking, etc.

	Ingo
