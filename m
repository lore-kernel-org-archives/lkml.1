Return-Path: <linux-kernel-owner+w=401wt.eu-S1758823AbYHOO07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823AbYHOO07 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 10:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755255AbYHOO0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 10:26:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56376 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755312AbYHOO0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 10:26:49 -0400
Date: Fri, 15 Aug 2008 16:26:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Jan Beulich <jbeulich@novell.com>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix spin_is_contended()
Message-ID: <20080815142635.GD12954@elte.hu>
References: <4897228E.76E4.0078.0@novell.com> <20080805020758.GB15075@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805020758.GB15075@wotan.suse.de>
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


* Nick Piggin <npiggin@suse.de> wrote:

> On Mon, Aug 04, 2008 at 02:38:54PM +0100, Jan Beulich wrote:
> > The masked difference is what needs to be compared against 1, rather
> > than the difference of masked values (which can be negative).
> 
> Dang, thanks.

applied to tip/x86/urgent, with your:

  Acked-by: Nick Piggin <npiggin@suse.de>

thanks Jan.

	Ingo
