Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbZHYTeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbZHYTeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 15:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756097AbZHYTeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 15:34:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56395 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755940AbZHYTeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 15:34:19 -0400
Date: Tue, 25 Aug 2009 21:33:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       shai@scalex86.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch] x86: 2.6.31-rc7 crash due to buggy flat_phys_pkg_id
Message-ID: <20090825193358.GA29968@elte.hu>
References: <20090824182659.GA6842@localdomain> <4A932809.1000103@kernel.org> <20090825012632.GB6842@localdomain> <4A9372A1.9090905@kernel.org> <20090825171716.GC6456@localdomain> <20090825181500.GB3277@elte.hu> <20090825183130.GA5806@lenovo> <4A943290.5080606@kernel.org> <20090825192757.GE6456@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825192757.GE6456@localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:

> On Tue, Aug 25, 2009 at 11:50:56AM -0700, Yinghai Lu wrote:
> >Cyrill Gorcunov wrote:
> >
> >initial apic id and apic id could be different.
> >
> >and we should use initial apic id to get correct phys pkg id in case BIOS set crazy apic id.
> >
> 
> Is there a specific bug we are fixing here?  Again, this behavior 
> was present from atleast 2.6.15-2.6.30 on 'flat' and older 
> 'cluster' apics, and intel documentation suggests local apic be 
> used.  Is there a specific bios bug that is being fixed?
> 
> (The BIOS is not supposed to set a crazy apic ID.  The BIOS is 
> buggy in that case -- Quoting section 9.4.6 from Intel System 
> programming guide vol 3A part 1:

That means very little. If Yinghai fixed a real bug in an existing 
system we should consider it. Yinghai?

	Ingo
