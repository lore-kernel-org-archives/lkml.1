Return-Path: <linux-kernel-owner+w=401wt.eu-S1757774AbYEMOVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774AbYEMOVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 10:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755608AbYEMOV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 10:21:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52364 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756922AbYEMOV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 10:21:26 -0400
Date: Tue, 13 May 2008 16:21:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] x86: Move es7000_plat out of mpparse.c
Message-ID: <20080513142115.GA30314@elte.hu>
References: <20080512152434.27570.7396.stgit@thinkpad> <20080513095528.GB24037@elte.hu> <20080513100214.GA1034@elte.hu> <48296C1B.2070808@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48296C1B.2070808@suse.de>
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


* Alexey Starikovskiy <astarikovskiy@suse.de> wrote:

> Ingo, please drop second patch, I'll rework it.

still fails with:

arch/x86/mach-generic/../../x86/mach-es7000/es7000plat.c: In function 
'es7000_rename_gsi':
arch/x86/mach-generic/../../x86/mach-es7000/es7000plat.c:64: error: 
'es7000_plat' undeclared (first use in this function)
arch/x86/mach-generic/../../x86/mach-es7000/es7000plat.c:64: error: 
(Each undeclared identifier is reported only once
arch/x86/mach-generic/../../x86/mach-es7000/es7000plat.c:64: error: for 
each function it appears in.)

with:

  http://redhat.com/~mingo/misc/config-Tue_May_13_16_16_10_CEST_2008.bad

	Ingo
