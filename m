Return-Path: <linux-kernel-owner+w=401wt.eu-S1765679AbXJRTUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765679AbXJRTUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 15:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763585AbXJRTU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 15:20:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40657 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759419AbXJRTUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 15:20:23 -0400
Date: Thu, 18 Oct 2007 21:20:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: wait_for_completion_interruptible() changes
Message-ID: <20071018192005.GA13900@elte.hu>
References: <Pine.LNX.4.62.0710181850370.22736@pademelon.sonytel.be> <20071018174124.GA30159@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018174124.GA30159@one.firstfloor.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > I suspect this is caused by the recent completion refactoring?
>  
> Yes. Here's a patch to fix it.
> 
> Fix return value of wait_for_completion_interruptible()
> 
> The recent w_f_c() changes broke the return value of 
> wait_for_completion_interruptible(). Previously it returned 0 on 
> success, now -1. Fix that.

argh. _Please_ be a bit more careful with cleanups.

applied.

	Ingo
