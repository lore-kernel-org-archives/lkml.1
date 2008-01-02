Return-Path: <linux-kernel-owner+w=401wt.eu-S1759919AbYABVeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759919AbYABVeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 16:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567AbYABVe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 16:34:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48126 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbYABVe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 16:34:28 -0500
Date: Wed, 2 Jan 2008 22:33:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: Mike Travis <travis@sgi.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       tglx@linutronix.de, mingo@redhat.com, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 05/10] x86_64: Use generic percpu
Message-ID: <20080102213331.GA14664@elte.hu>
References: <20071228001046.854702000@sgi.com> <20071228001047.556634000@sgi.com> <200712281354.52453.ak@suse.de> <47757311.5050503@sgi.com> <20071230141829.GA28415@elte.hu> <477916ED.8010602@sgi.com> <47792295.8070001@sgi.com> <20080101191758.GA14045@elte.hu> <Pine.LNX.4.64.0801021302530.22538@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801021302530.22538@schroedinger.engr.sgi.com>
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


* Christoph Lameter <clameter@sgi.com> wrote:

> On Tue, 1 Jan 2008, Ingo Molnar wrote:
> 
> > FYI, i tried your patchset on 2.6.24-rc6+x86.git, and randconfig testing 
> > found a faulty 32-bit config below - the bootup would spontaneously 
> > reboot shortly after hitting user-space. (which suggests a triple fault) 
> > No log messages on the serial console.
> 
> The triple fault does not occur without the patchset?

correct.

	Ingo
