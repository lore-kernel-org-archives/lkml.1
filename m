Return-Path: <linux-kernel-owner+w=401wt.eu-S1764622AbYCFL2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764622AbYCFL2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 06:28:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755962AbYCFL2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 06:28:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49166 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755534AbYCFL2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 06:28:46 -0500
Date: Thu, 6 Mar 2008 12:28:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Jan Beulich <jbeulich@novell.com>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix typo(?) in step.c
Message-ID: <20080306112819.GC17906@elte.hu>
References: <47CE69B0.76E4.0078.0@novell.com> <20080305134150.GA16477@elte.hu> <20080306075223.BA28B2700FD@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080306075223.BA28B2700FD@magilla.localdomain>
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


* Roland McGrath <roland@redhat.com> wrote:

> The bogon came in commit eee3af4a2c83a97fff107ddc445d9df6fded9ce4, the 
> introduction of the ptrace BTS stuff.  Sorry I did not scour and cite 
> every problem in that patch, since I had NAK'd the entire thing as 
> needing more careful review and incremental introduction after 2.6.25.

note that in -rc4 all those BTS ptrace extensions are disabled, see:

|   commit b4ef95de00be4c2c30feccf607a45093c8c118b7
|   Author: Ingo Molnar <mingo@elte.hu>
|   Date:   Tue Feb 26 09:40:27 2008 +0100
|
|     x86: disable BTS ptrace extensions for now

	Ingo
