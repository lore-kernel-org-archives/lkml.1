Return-Path: <linux-kernel-owner+w=401wt.eu-S1760630AbYEFMiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760630AbYEFMiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 08:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYEFMiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 08:38:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40643 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbYEFMiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 08:38:07 -0400
Date: Tue, 6 May 2008 14:37:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Jones <davej@codemonkey.org.uk>, tglx@linutronix.de,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [X86] Add new cache descriptor.
Message-ID: <20080506123753.GO32591@elte.hu>
References: <20080505215252.GA31722@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505215252.GA31722@codemonkey.org.uk>
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


* Dave Jones <davej@codemonkey.org.uk> wrote:

> The latest rev of Intel doc AP-485 details a new cache descriptor that 
> we don't yet support. A 6MB 24-way assoc L2 cache.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>

>  	{ 0x4d, LVL_3,     16384 },	/* 16-way set assoc, 64 byte line size */
> +	{ 0x4e, LVL_2,      6144 },	/* 24-way set assoc, 64 byte line size */

applied, thanks Dave.

	Ingo
