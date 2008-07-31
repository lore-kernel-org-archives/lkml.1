Return-Path: <linux-kernel-owner+w=401wt.eu-S1757919AbYGaVZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919AbYGaVZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 17:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbYGaVZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 17:25:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33345 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245AbYGaVZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 17:25:05 -0400
Date: Thu, 31 Jul 2008 23:24:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>, Peter Oruba <peter.oruba@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/4] x86: AMD microcode patch loading v2 fixes
Message-ID: <20080731212441.GF2729@elte.hu>
References: <20080729154103.007575982@amd.com> <b647ffbd0807290918kaa0a05es3cebf7a6f15fb790@mail.gmail.com> <488F581B.7060009@qualcomm.com> <48903431.9060707@amd.com> <b647ffbd0807300257x43dd6018o59533bec11b7a504@mail.gmail.com> <b647ffbd0807300334q57cdca6fu474cc7b6bed36102@mail.gmail.com> <48909854.2040201@qualcomm.com> <b647ffbd0807301138i5f721a39p9b20e4e918aa07b7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0807301138i5f721a39p9b20e4e918aa07b7@mail.gmail.com>
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


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> I've even suggested to consider doing microcode update somewhere 
> earlier in start_secondary() (say, right before cpu_idle()). So it'd 
> be done as ealry as possible + we don't mess up with cpu-hotplug 
> events.

i have no problems with that approach in principle. Microcode updates 
are special and black magic things anyway.

	Ingo
