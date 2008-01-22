Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336AbYAVNrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbYAVNrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 08:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751134AbYAVNr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 08:47:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53930 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbYAVNr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 08:47:26 -0500
Date: Tue, 22 Jan 2008 14:47:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila@kolumbus.fi>
Subject: Re: [PATCH] x86_32: Remove unnecessary use of %ebx as the boot cpu
	flag
Message-ID: <20080122134700.GG7304@elte.hu>
References: <1200953721-3815-2-git-send-email-ijc@hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200953721-3815-2-git-send-email-ijc@hellion.org.uk>
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


* Ian Campbell <ijc@hellion.org.uk> wrote:

> Currently in head_32.S there are two ways we test to see if we are the 
> boot cpu.  By looking at %ebx and by looking at the static variable 
> ready.  When changing things around I have found that it gets tricky 
> to preserve %ebx.  So this patch just switches head.S over to the more 
> reliable test of always using ready.
> 
> Hopefully later we can kill these tests entirely.

FYI, i've applied this patch and your next patch to x86.git. (still 
waiting with the third patch, until your discussion of this topic with 
Peter settles down.) Thanks,

	Ingo
