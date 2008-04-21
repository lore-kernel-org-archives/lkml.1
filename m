Return-Path: <linux-kernel-owner+w=401wt.eu-S1755701AbYDUUK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbYDUUK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 16:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbYDUUKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 16:10:21 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:45921 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbYDUUKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 16:10:21 -0400
Date: Mon, 21 Apr 2008 23:09:49 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: Voyager phys_cpu_present_map compile error
Message-ID: <20080421200949.GB2633@cs181133002.pp.htv.fi>
References: <20080421000238.GD26897@cs181133002.pp.htv.fi> <20080421085314.GI26897@cs181133002.pp.htv.fi> <20080421120054.GA6788@elte.hu> <1208793533.3640.24.camel@localhost.localdomain> <20080421195148.GG8770@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080421195148.GG8770@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 09:51:48PM +0200, Ingo Molnar wrote:
> 
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > > thanks, the three patches below should fix it.
> > > 
> > > i ended up excluding Voyager configs from our test space some time 
> > > ago (and VISWS as well - there's one more visws fix in x86.git), 
> > > that's how this broke. These subarchitectures seem not to be used at 
> > > all and the code wont boot on normal PCs. We could mark it BROKEN 
> > > but the fix seems simple in any case.
> > 
> > The voyager pieces of this code look fine to me.  I can't test at the 
> > moment because we're having the carpets cleaned and I can't get down 
> > into the cellar where the systems are, but I'll do so shortly.
> 
> ok, that's good enough - that's why i excluded it from the auto-qa 
> test-space as well. Adrian, could you please remove it from your config 
> testset as well? If a user enables that config option it wont boot 
> anyway so it's not a problem in practice.

Who said that Voyager won't boot?

And I'm the first to remove non-working code, but as long as we 
ship it it should be in the best possible state.

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

