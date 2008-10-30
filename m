Return-Path: <linux-kernel-owner+w=401wt.eu-S1755058AbYJ3Wz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbYJ3Wz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 18:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbYJ3WzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 18:55:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41827 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbYJ3WzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 18:55:21 -0400
Date: Thu, 30 Oct 2008 23:55:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org,
       tim@scalemp.com, shai@scalex86.org,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] x86: Fix /dev/mem mmap breakage when PAT is disabled
Message-ID: <20081030225502.GA28943@elte.hu>
References: <20081030020203.GA12423@localdomain> <20081030182902.GF14102@elte.hu> <20081030205921.GA6583@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030205921.GA6583@localdomain>
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


* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:

> On Thu, Oct 30, 2008 at 07:29:02PM +0100, Ingo Molnar wrote:
> >
> >I guess it might be cleaner to push this check into the 
> >range_is_allowed() function?
> >
> 
> OK.  Here it is.

applied to tip/x86/urgent, thanks!

	Ingo
