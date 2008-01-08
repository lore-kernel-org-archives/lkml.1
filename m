Return-Path: <linux-kernel-owner+w=401wt.eu-S1756237AbYAHIOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbYAHIOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 03:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbYAHIOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 03:14:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57774 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbYAHIOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 03:14:09 -0500
Date: Tue, 8 Jan 2008 09:13:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Andi Kleen <andi@firstfloor.org>, Robert Hancock <hancockr@shaw.ca>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, akpm@osdl.org,
       rajesh.shah@intel.com, greg@kroah.com
Subject: Re: MCFG ACPI patch in git-x86 causes boot regression
Message-ID: <20080108081346.GE31838@elte.hu>
References: <20080107224757.GA2336@basil.nowhere.org> <200801071452.15045.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801071452.15045.jbarnes@virtuousgeek.org>
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


* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> > On previous kernels the MCFG was rejected because it wasn't e820 
> > reserved:
> 
> Yep, this patch (as was stated many times) requires other fixes to PCI 
> probing--either disabling decode, not using mmconfig unless absolutely 
> required, or one of the other discussed changes.  I'm not sure why it 
> was pushed before one of those changes went in.

yeah - we try to pick up patches early into x86.git, so that integration 
issues can be found as early as possible. But this patch should live in 
Greg's tree - just sent it back.

	Ingo
