Return-Path: <linux-kernel-owner+w=401wt.eu-S1764023AbZDHOtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764023AbZDHOtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757203AbZDHOs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:48:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45564 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753458AbZDHOs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:48:58 -0400
Date: Wed, 8 Apr 2009 16:48:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: Bert Wesarg <bert.wesarg@googlemail.com>, linux-kernel@vger.kernel.org,
       jeff@garzik.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 54/56] x86: Remove void casts
Message-ID: <20090408144842.GK12931@elte.hu>
References: <1239189748-11703-52-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-53-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-54-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-55-git-send-email-jwjstone@fastmail.fm> <36ca99e90904080518qf81b483h6ed2bc9752ee0d1e@mail.gmail.com> <49DCAE97.8040602@fastmail.fm> <20090408140637.GC12931@elte.hu> <49DCB140.7000603@fastmail.fm> <20090408144055.GH12931@elte.hu> <49DCB8C5.4090108@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DCB8C5.4090108@fastmail.fm>
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


* Jack Stone <jwjstone@fastmail.fm> wrote:

> Ingo Molnar wrote:
> > * Jack Stone <jwjstone@fastmail.fm> wrote:
> >
> >   
> >> Ingo Molnar wrote:
> >>     
> >>> * Jack Stone <jwjstone@fastmail.fm> wrote:
> >>>
> >>>   
> >>>       
> >>>> Fixed patch
> >>>>
> >>>> Thanks,
> >>>>     
> >>>>         
> >>> Hm, what was fixed?
> >>>   
> >>>       
> >> I removed casts on pointer arithmetic which probably still needed to be
> >> there to do the arithmetic properly.
> >>     
> >
> > ... which pretty much proves the point that these patches should 
> > not go via any "trivial" tree.
> >
> > Those additions of mmu pointers you did were outright lethal, i 
> > doubt this stuff could have booted on both 32-bit and 64-bit 
> > x86.
> >
> > Please dont do this. Or if you do, please double check your 
> > change and double check that the relevant vmlinux disassembly is 
> > still bit for bit the same.
> >   
> 
> Thats what I meant by fixed - those changes were removed from the 
> patch.

No, i mean, this approach should be changed, and i dont think any 
type cast change should go via any trivial tree. It's easy to mess 
it up. Please submit them to the maintainer trees.

	Ingo
