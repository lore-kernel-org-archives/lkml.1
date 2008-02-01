Return-Path: <linux-kernel-owner+w=401wt.eu-S1757300AbYBAQU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbYBAQU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 11:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755013AbYBAQUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 11:20:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47755 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845AbYBAQUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 11:20:13 -0500
Date: Fri, 1 Feb 2008 17:20:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] let LOG_BUF_SHIFT default to 17
Message-ID: <20080201162003.GB15156@elte.hu>
References: <20080128221223.GE8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128221223.GE8767@does.not.exist>
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


* Adrian Bunk <bunk@kernel.org> wrote:

> 16 kB is often no longer enough for a normal boot of an UP system.
> 
> And even less when people e.g. use suspend.
> 
> 17 seems to be a more reasonable default for current kernels on 
> current hardware (it's just the default, anyone who is memory limited 
> can still lower it).

agreed - but i think the default should be even higher. Many reported 
dmesg's are truncated at the really interesting bits so it's a real 
problem in practice.

	Ingo
