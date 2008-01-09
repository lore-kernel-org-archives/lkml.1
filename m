Return-Path: <linux-kernel-owner+w=401wt.eu-S1758959AbYAIBVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959AbYAIBVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 20:21:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbYAIBU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 20:20:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57252 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbYAIBUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 20:20:55 -0500
Date: Wed, 9 Jan 2008 02:20:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 00 of 10] x86: unify asm/pgtable.h
Message-ID: <20080109012042.GA1133@elte.hu>
References: <20080108234449.GA24274@elte.hu> <20080109000146.GA29095@elte.hu> <47841194.2010208@goop.org> <20080109002014.GB31289@elte.hu> <20080109002803.GA3732@elte.hu> <20080109003034.GA4658@elte.hu> <47841B09.3020507@goop.org> <20080109005914.GA24228@elte.hu> <47841E3C.9020106@goop.org> <20080109011233.GD25945@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109011233.GD25945@bingen.suse.de>
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


* Andi Kleen <ak@suse.de> wrote:

> >> this code is plain buggy but fixing it triggered driver bugs in the 
> >> past so we've been procrastinating it forever ...
> >>   
> >
> > What kind of driver bugs?  Do drivers manage to get into the other 
> > branch
> 
> That was just the return value issue that caused drivers to fail 
> through ioremap() iirc. It would error out for unmapped holes and then 
> fail ioremap I don't think it's related.

in -mm we had a patch where the error behavior was consolidated but it 
broke on some boxes.

	Ingo
