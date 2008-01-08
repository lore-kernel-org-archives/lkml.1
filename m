Return-Path: <linux-kernel-owner+w=401wt.eu-S1759430AbYAHQTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430AbYAHQTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 11:19:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbYAHQTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 11:19:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40306 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbYAHQTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:19:14 -0500
Date: Tue, 8 Jan 2008 17:18:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: DM <dm.n9107@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, ak@suse.de
Subject: Re: [patch 2/2] track and print last unloaded module in the oops
	trace
Message-ID: <20080108161846.GD32273@elte.hu>
References: <20080106151946.50c3d8cc@laptopd505.fenrus.org> <5eeb9ad90801080551n562b9f15o27b495495a452c22@mail.gmail.com> <20080108062656.311cd3aa@laptopd505.fenrus.org> <5eeb9ad90801080639h2992e9b7maec0339e4f763f65@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5eeb9ad90801080639h2992e9b7maec0339e4f763f65@mail.gmail.com>
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


* DM <dm.n9107@gmail.com> wrote:

> On Jan 8, 2008 3:26 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> > >
> > > Why use sprintf? If a module name contains the % character we could
> > > overflow the buffer. Or is module-unloading root-only and we don't
> > > care?
> >
> > module loading isn't just root only; the name comes from an already loaded module.
> > If you can load kernel modules of your choice you own the entire kernel already anway
> >
> 
> Still, strcpy seems like a better choice IMHO.

agreed, this just isnt obvious IMO:

+       sprintf(last_unloaded_module, mod->name);

	Ingo
