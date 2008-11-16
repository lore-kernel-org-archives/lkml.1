Return-Path: <linux-kernel-owner+w=401wt.eu-S1752261AbYKPH0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbYKPH0h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 02:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbYKPH03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 02:26:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53757 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbYKPH02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 02:26:28 -0500
Date: Sun, 16 Nov 2008 08:26:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Markus Metzger <markus.t.metzger@googlemail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, work <markus.t.metzger@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       stephane eranian <eranian@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] x86, bts: fix unlock problem in ds.c
Message-ID: <20081116072614.GC19646@elte.hu>
References: <1226743217.6162.4.camel@raistlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226743217.6162.4.camel@raistlin>
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


* Markus Metzger <markus.t.metzger@googlemail.com> wrote:

> Fix a problem where ds_request() returned an error without releasing 
> the ds lock.
> 
> Reported-by: Stephane Eranian <eranian@gmail.com>
> Signed-off-by: Markus Metzger <markus.t.metzger@gmail.com>

applied to tip/x86/urgent, thanks Markus!

i also reviewed the other locking branches there and they seem to be 
fine.

	Ingo
