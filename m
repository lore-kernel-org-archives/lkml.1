Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbZFWTUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbZFWTUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 15:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbZFWTUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 15:20:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43385 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbZFWTUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 15:20:43 -0400
Date: Tue, 23 Jun 2009 21:20:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yinghai@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       sfi-devel@simplefirmware.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Feng Tang <feng.tang@intel.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 3/8] SFI: core support
Message-ID: <20090623192024.GC14852@elte.hu>
References: <7425334c8329b15bec7cb4ecd0b17af042e97465.1245740912.git.len.brown@intel.com> <8d9bab79ce1169afd419035f70177e52d47626ca.1245740912.git.len.brown@intel.com> <20090623075643.GC6397@elte.hu> <alpine.LFD.2.00.0906231312550.21402@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0906231312550.21402@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Len Brown <lenb@kernel.org> wrote:

> Re: #define PREFIX "SFI: "
> 
> The SFI code uses all pr_info/debug/warning/err format
> and so it looks like the way to go is like this;
> 
> #define KMSG_COMPONENT "SFI"
> #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
> 
> and get rid of the PREFIX stuff in the actual messages.
> Is that the recommended way to go these days?

Yeah, overloadig pr_fmt looks entirely correct and per design. That 
will make it even cleaner.

	Ingo
