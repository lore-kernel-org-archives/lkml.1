Return-Path: <linux-kernel-owner+w=401wt.eu-S1760315AbXKPIhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760315AbXKPIhB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 03:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbXKPIgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 03:36:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60755 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170AbXKPIgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 03:36:51 -0500
Date: Fri, 16 Nov 2007 09:36:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: x86: disable preemption in delay_tsc()
Message-ID: <20071116083627.GA18225@elte.hu>
References: <200711150400.lAF40lIr020160@hera.kernel.org> <20071115194116.12c7a0f6@laptopd505.fenrus.org> <473D5016.4000105@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473D5016.4000105@qumranet.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Avi Kivity <avi@qumranet.com> wrote:

> You can use preemption notifiers to get a callback when you are 
> preempted.  Not sure what you'd to with that callback, though.

but that should not be needed in this case. Why doesnt the TSC using 
delay loop simply poll the CPU it is on and fix up the TSC?

	Ingo
