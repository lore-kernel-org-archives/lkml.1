Return-Path: <linux-kernel-owner+w=401wt.eu-S1753999AbYANJAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbYANJAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 04:00:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbYANJAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 04:00:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48102 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbYANJAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 04:00:24 -0500
Date: Mon, 14 Jan 2008 10:00:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: travis@sgi.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] x86: Reduce memory and intra-node effects with
	large count NR_CPUs
Message-ID: <20080114090010.GA5404@elte.hu>
References: <20080113183453.973425000@sgi.com> <20080114081418.GB18296@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114081418.GB18296@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > 32cpus			  1kcpus-before		    1kcpus-after
> >    7172678 Total	   +23314404 Total	       -147590 Total
> 
> 1kcpus-after means it's +23314404-147590, i.e. +23166814? (i.e. a 0.6% 
> reduction of the bloat?)

or if it's relative to 32cpus then that's an excellent result :)

	Ingo
