Return-Path: <linux-kernel-owner+w=401wt.eu-S1762969AbYAaVGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762969AbYAaVGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 16:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbYAaVGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 16:06:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35659 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbYAaVGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 16:06:09 -0500
Date: Thu, 31 Jan 2008 22:05:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86_64: make bootmap_start page align v6
Message-ID: <20080131210553.GA15221@elte.hu>
References: <200801291113.35974.yinghai.lu@sun.com> <200801311434.31011.ak@suse.de> <200801311237.26080.yinghai.lu@sun.com> <200801311244.11206.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801311244.11206.yinghai.lu@sun.com>
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


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> [PATCH] x86_64: make bootmap_start page align v6
> 
> need to apply after x86_64: add debug name for early_res
> 
> boot oops when system get 64g or 128 installed

thanks - this v6 approach looks a _lot_ saner because it solves the core 
problem: the fragility of the early allocator code. They are also 
cleanups, besides being fixes. Applied.

does this solve all the boot problems you were seeing with 64 or 128 GB 
of RAM?

	Ingo
