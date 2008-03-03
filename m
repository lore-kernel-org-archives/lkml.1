Return-Path: <linux-kernel-owner+w=401wt.eu-S1759817AbYCCRgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759817AbYCCRgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758570AbYCCRXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:23:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38629 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758572AbYCCRXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:23:08 -0500
Date: Mon, 3 Mar 2008 18:22:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de
Subject: Re: [PATCH 0/52] First attempt at smp integration
Message-ID: <20080303172215.GA7918@elte.hu>
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
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


* Glauber Costa <gcosta@redhat.com> wrote:

> Hi,
> 
> This series of patches does a first attempt at smp integration (I call 
> it first, although I don't believe it's too far away from a real one). 
> The series comprises 52 patches, and the full diffstat says in the 
> end:
> 
> 	 34 files changed, 1858 insertions(+), 2344 deletions(-)
> 
> smp_32.c and smp_64.c are completely gone. smp.h and smpboot_{32,64}.c 
> are not, although substantially reduced. I know that ideally, no 
> leftovers are wanted, but the series were already big enough (I tried 
> to split the patches as much as I could), so I considered this a good 
> cutting point. If this is all agreed upon and merged, I'll start 
> looking at the other bits that are left.
> 
> All patches are tested is various random x86 subarchitectures, and all 
> of them works. The result also boots fine in mine x86_64 and i386 
> boxes.

wow, really nice work and the result looks awesome! I'll put this into 
x86.git and see how it goes.

	Ingo
