Return-Path: <linux-kernel-owner+w=401wt.eu-S1759921AbYFYPpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759921AbYFYPpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 11:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758810AbYFYPpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 11:45:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34801 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbYFYPpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 11:45:20 -0400
Date: Wed, 25 Jun 2008 17:44:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bernhard Walle <bwalle@suse.de>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, x86@kernel.org, vgoyal@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] e820_update_range(): Allow specifying ULLONG_MAX
Message-ID: <20080625154459.GD18796@elte.hu>
References: <1214318125-32619-1-git-send-email-bwalle@suse.de> <1214318125-32619-3-git-send-email-bwalle@suse.de> <86802c440806241301x4d124335h2888de9e915208ae@mail.gmail.com> <86802c440806241321g6c5cd64eoe504d6029de6fe5a@mail.gmail.com> <20080625140511.6660ff68@halley.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080625140511.6660ff68@halley.suse.de>
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


* Bernhard Walle <bwalle@suse.de> wrote:

> * Yinghai Lu [2008-06-24 13:21]:
> >
> > > it seems we should let the caller to use
> > > e820_update_range(start, ULLONG_MAX - size,....)
> > >
> > > so you don't need to touch this func.
> > 
> > or add sanitary check before using size in this func like
> > if (size > ULLONG_MAX - start)
> >      size = ULLONG_MAX - start;
> > 
> > e820_remove_range need to the same thing
> 
> I like that. I think the complexity should be in the function, and not 
> in the caller's function.

ok - i'll wait for v2 of these patches, which will have the feedback 
from Yinghai incorporated - agreed? (Please Cc: Yinghai on the next 
submission of this series) Thanks,

	Ingo
