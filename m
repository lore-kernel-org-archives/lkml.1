Return-Path: <linux-kernel-owner+w=401wt.eu-S1752411AbZCHKUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbZCHKUu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 06:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbZCHKUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 06:20:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55072 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbZCHKUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 06:20:38 -0400
Date: Sun, 8 Mar 2009 11:20:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, npiggin@suse.de,
       akpm@linux-foundation.org
Subject: Re: [PATCH UPDATED 4/4] percpu: finer grained locking to break
	deadlock and allow atomic free
Message-ID: <20090308102017.GD14133@elte.hu>
References: <1236354883-25063-1-git-send-email-tj@kernel.org> <1236354883-25063-5-git-send-email-tj@kernel.org> <49B20AF8.6080504@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B20AF8.6080504@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> IRQ spin lock ops should be used to allow free to be called 
> from IRQ context.  Fixed.  The git tree is updated too.  The 
> new commit ID is ccea34b5d0fbab081496d1860f31acee99fa8a6d.
> 
> Thanks.

Pulled, thanks Tejun!

	Ingo
