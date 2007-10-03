Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbXJCKyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbXJCKyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 06:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754244AbXJCKys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 06:54:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44681 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859AbXJCKyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 06:54:47 -0400
Date: Wed, 3 Oct 2007 12:54:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [bootup warning] "driver" has no release callback, .23-rc9
Message-ID: <20071003105442.GA7087@elte.hu>
References: <20071003070816.GA1208@elte.hu> <1191405584.28201.31.camel@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1191405584.28201.31.camel@gaivota>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> Hi Ingo,
> 
> Em Qua, 2007-10-03 às 09:08 +0200, Ingo Molnar escreveu:
> > FYI, there are 7 V4L drivers that produce this (non-fatal) warning:
> 
> Those warnings are inoffensive ;) V4L core does provide a generic 
> release callback. Anyway, we'll take a look on it and fix, to avoid 
> the warnings.

ok :-) Just wanted to let you know that these are the ones that 
triggered in an allyesconfig bzImage bootup.

	Ingo
