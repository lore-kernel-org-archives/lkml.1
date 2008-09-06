Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbYIFRt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbYIFRt2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 13:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbYIFRtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 13:49:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49139 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbYIFRtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 13:49:19 -0400
Date: Sat, 6 Sep 2008 19:49:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Jan Beulich <jbeulich@novell.com>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix ticket spin lock asm constraints
Message-ID: <20080906174906.GS4856@elte.hu>
References: <48B7FFB3.76E4.0078.0@novell.com> <20080830052801.GA16897@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080830052801.GA16897@wotan.suse.de>
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

> Hi,
> 
> All these ticket lock patches look pretty good to me. Thanks for going over
> it so thoroughly.

yes - and they are all working fine here as well in testing. They are 
queued up for v2.6.28.

	Ingo
