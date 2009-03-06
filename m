Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbZCFQYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbZCFQYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 11:24:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbZCFQYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 11:24:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43681 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbZCFQYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 11:24:24 -0500
Date: Fri, 6 Mar 2009 17:24:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Yeisley <dan.yeisley@unisys.com>, Yinghai Lu <yinghai@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] MSI: check for BIOS assigned addresses
Message-ID: <20090306162402.GA8936@elte.hu>
References: <1236352309.31604.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236352309.31604.2.camel@localhost.localdomain>
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


* Daniel Yeisley <dan.yeisley@unisys.com> wrote:

> When creating MSI addresses the kernel makes them up and 
> writes them to the hardware without first checking for what 
> the system BIOS may have assigned.  The patch below checks for 
> already assigned values, and leaves them alone if they exist.
> 
> Signed-off-by: Dan Yeisley <dan.yeisley@unisys.com>

What happens without this fix - do you get non-working cards? 
Boot hang? Or a suboptimal layout?

	Ingo
