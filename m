Return-Path: <linux-kernel-owner+w=401wt.eu-S1761819AbYFWRxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761819AbYFWRxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 13:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbYFWRww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 13:52:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38614 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058AbYFWRww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 13:52:52 -0400
Date: Mon, 23 Jun 2008 19:52:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nathan Lynch <ntl@pobox.com>
Cc: linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com
Subject: Re: [patch] hackbench: flush buffers before fork
Message-ID: <20080623175239.GA31430@elte.hu>
References: <20080623174333.GF9594@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080623174333.GF9594@localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0008]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nathan Lynch <ntl@pobox.com> wrote:

> Here's a fixlet for the hackbench program found at
> 
> http://people.redhat.com/mingo/cfs-scheduler/tools/hackbench.c
> 
> When redirecting hackbench output I am seeing multiple copies of the 
> "Running with %d*40 (== %d) tasks" line.  Need to flush the buffered 
> output before forking.

thanks Nathan, applied.

	Ingo
