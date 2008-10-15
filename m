Return-Path: <linux-kernel-owner+w=401wt.eu-S1752854AbYJOJeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbYJOJeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 05:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbYJOJeC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 05:34:02 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58171 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbYJOJeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 05:34:00 -0400
Date: Wed, 15 Oct 2008 11:33:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: linux-next: origin tree build failure
Message-ID: <20081015093319.GA19403@elte.hu>
References: <20081015095916.f30c0979.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081015095916.f30c0979.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Linus, Mark,
> 
> Today's linux-next build (just Linus' tree) (x86_64 allmodconfig) failed
> like this:
> 
> drivers/mfd/wm8350-core.c: In function 'wm8350_device_init':
> drivers/mfd/wm8350-core.c:1220: error: 'NO_IRQ' undeclared (first use in this function)
> 
> Caused by commit ebccec0fa4e35dff0c18663a492a65f4dc6cad7a ("mfd: Add
> WM8350 interrupt support").

hm:

 Author:     Mark Brown <broonie@opensource.wolfsonmicro.com>
 AuthorDate: Fri Oct 10 15:58:14 2008 +0100
 Commit:     Liam Girdwood <lrg@slimlogic.co.uk>
 CommitDate: Mon Oct 13 21:51:56 2008 +0100

if a patch is merged as agressively as that, it should at minimum be 
tested a bit.

	Ingo
