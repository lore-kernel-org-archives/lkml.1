Return-Path: <linux-kernel-owner+w=401wt.eu-S1754163AbXJHLhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbXJHLhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 07:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbXJHLhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 07:37:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55664 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628AbXJHLg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 07:36:59 -0400
Date: Mon, 8 Oct 2007 13:36:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/6] scheduler: Remove some unnecessary gotos in
	sched.c
Message-ID: <20071008113651.GA22199@elte.hu>
References: <200710071059.126674000@suse.de> <20071007205954.4053C13E06@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071007205954.4053C13E06@wotan.suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0024]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@suse.de> wrote:

> No need to be more spagetti than absolutely necessary.
> 
> Replace loops implemented with gotos with real loops. Replace err = 
> ...; goto x; x: return err; with return ...;
> 
> No functional changes.

thanks, applied.

	Ingo
