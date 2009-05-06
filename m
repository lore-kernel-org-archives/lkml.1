Return-Path: <linux-kernel-owner+w=401wt.eu-S1757095AbZEFHmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095AbZEFHmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 03:42:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbZEFHl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 03:41:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39440 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381AbZEFHl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 03:41:57 -0400
Date: Wed, 6 May 2009 09:41:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
       chrisw@sous-sol.org, roland@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ptrace: ptrace_attach: check PF_KTHREAD +
	exit_state instead of ->mm
Message-ID: <20090506074101.GD17457@elte.hu>
References: <20090505224722.GA954@redhat.com> <20090505164733.54cd4ca4.akpm@linux-foundation.org> <20090506070837.GA3223@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506070837.GA3223@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, May 05, 2009 at 04:47:33PM -0700, Andrew Morton wrote:
> > These patches make a mess of utrace-core.patch.  Do we really want to do that?
> 
> Yes.  All these patches from Oleg are preparations for actually 
> doing a utrace merge in a sane way.  I don't really think utrace 
> should be in -mm at this point where active ptrace work is going 
> on.

Yes, as i said it in earlier threads, lacking other in-tree use, 
utrace is only acceptable for upstream if it materially cleans up 
the ptrace code here and now - without any wide #ifdefs like some of 
the earlier patches did.

The latest patches from Oleg clearly go in this direction, which is 
a very promising development!

	Ingo
