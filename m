Return-Path: <linux-kernel-owner+w=401wt.eu-S1758688AbXFUUuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688AbXFUUuQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 16:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756404AbXFUUuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 16:50:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45441 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756341AbXFUUuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 16:50:03 -0400
Date: Thu, 21 Jun 2007 22:49:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oliver Pinter <oliver.pntr@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>, miklos@szeredi.hu
Subject: Re: [locking api] It's ok?
Message-ID: <20070621204923.GA5171@elte.hu>
References: <6101e8c40706211255x61f49654p256f0e03436119b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6101e8c40706211255x61f49654p256f0e03436119b@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Oliver Pinter <oliver.pntr@gmail.com> wrote:

> Hello!
> 
> In all kernel version on my system already see this locking api 
> result:

it's OK:

> --------------------------------------------------------
> 145 out of 218 testcases failed, as expected. |
> ----------------------------------------------------

if you want a 'perfect' result and full checking, turn this option on:

 # CONFIG_PROVE_LOCKING is not set

	Ingo
