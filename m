Return-Path: <linux-kernel-owner+w=401wt.eu-S1755777AbYFRSfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbYFRSfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 14:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbYFRSez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 14:34:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39050 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397AbYFRSey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 14:34:54 -0400
Date: Wed, 18 Jun 2008 20:33:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per
	cpu area
Message-ID: <20080618183359.GA24614@elte.hu>
References: <20080604003018.538497000@polaris-admin.engr.sgi.com> <20080604003019.509483000@polaris-admin.engr.sgi.com> <20080605102222.GA21319@elte.hu> <484EF29C.7080100@sgi.com> <485947A8.8060801@goop.org> <4859511E.5050605@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4859511E.5050605@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Hi Jeremy,
> 
> I'm not finding that code in the tip/latest or linux-next branches... 
> ?
> 
> I can send you my latest version of the patch which is better than the 
> previous but still is having problems with the config file that Ingo 
> sent out.  (It also has a weird quirk that it will hang and reboot 
> after about 30 seconds with or without my patch.)

the patch is not in -tip yet because we dont keep known-broken patches 
applied unless there's some really strong reason to do so.

	Ingo
