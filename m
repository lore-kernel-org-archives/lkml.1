Return-Path: <linux-kernel-owner+w=401wt.eu-S1763109AbYARQVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763109AbYARQVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 11:21:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762369AbYARQVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 11:21:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33394 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762215AbYARQVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:21:33 -0500
Date: Fri, 18 Jan 2008 17:21:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, jbeulich@novell.com,
       venkatesh.pallipadi@intel.com
Subject: Re: CPA boot crash (was: [PATCH] [0/36] Great change_page_attr
	patch series v3)
Message-ID: <20080118162118.GA6819@elte.hu>
References: <200801161114.239449000@suse.de> <200801181701.04549.ak@suse.de> <20080118160757.GA24507@elte.hu> <200801181716.06093.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801181716.06093.ak@suse.de>
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


* Andi Kleen <ak@suse.de> wrote:

> > > (except for the white space changes, but that can be redone once 
> > > everything settled down again). Then it will be bisectable.
> > 
> > it's a revert barrier (within v2.6.25),
> 
> What is a revert barrier?
>
> Anyways of course the way to handle that is the same as with the other 
> undo patches: drop the original white space changes 
> (ddb53b5735793a19dc17bcd98b050f672f) completely and then drop that 
> undo patch too. The white space changes haven't reached Linus yet so 
> you can just make them disappear completely from known history.

we dont want them to disappear, due to the second half of:

   http://lkml.org/lkml/2008/1/18/112

we want easy-cleanups first, difficult changes applied second. It's a 
well-established concept.

	Ingo
