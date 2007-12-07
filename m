Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbXLGR4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbXLGR4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 12:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757271AbXLGRzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 12:55:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58228 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757485AbXLGRzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 12:55:53 -0500
Date: Fri, 7 Dec 2007 18:55:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <clameter@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: Major regression on hackbench with SLUB
Message-ID: <20071207175527.GA19173@elte.hu>
References: <1197049846.1645.68.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197049846.1645.68.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0007]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> The regression is that hackbench slows down tremendously. It goes from 
> running just under 2 seconds to running around 14 seconds.

ouch ...

it might make sense to check the SLUB patches from -mm ontop of vanilla 
as well - while that might be of little comfort as far as 2.6.24 goes, 
it at least gives us the info whether this is something that has been 
fixed in the latest SLUB code.

	Ingo
