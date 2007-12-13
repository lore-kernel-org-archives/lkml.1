Return-Path: <linux-kernel-owner+w=401wt.eu-S1760256AbXLMKOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760256AbXLMKOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 05:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbXLMKOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 05:14:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47888 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbXLMKOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 05:14:10 -0500
Date: Thu, 13 Dec 2007 11:13:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Michael Buesch <mb@bu3sch.de>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux@bohmer.net, jonathan@jonmasters.org,
       matthias.kaehlcke@gmail.com, kjwinchester@gmail.com, mbuesch@freenet.de
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore
	to mutex
Message-ID: <20071213101327.GM8977@elte.hu>
References: <20071213003028.676998182@mvista.com> <20071213003032.547362071@mvista.com> <200712130148.22727.mb@bu3sch.de> <1197508801.22951.40.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197508801.22951.40.camel@imap.mvista.com>
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


* Daniel Walker <dwalker@mvista.com> wrote:

> > This driver is scheduled for removal, so I'd not touch it anymore to 
> > avoid the possibility to introduce a lastminute regression. The new 
> > drivers (b43 and b43legacy) have this fixed (in a different way by 
> > completely removing it).
> 
> When is the removal scheduled?

$ grep -i bcm Documentation/feature-removal-schedule.txt
$

might make sense to update this file.

	Ingo
