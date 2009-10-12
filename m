Return-Path: <linux-kernel-owner+w=401wt.eu-S1755726AbZJLKKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726AbZJLKKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 06:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbZJLKKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 06:10:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33161 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680AbZJLKKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 06:10:13 -0400
Date: Mon, 12 Oct 2009 12:09:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jason Baron <jbaron@redhat.com>, swhiteho@redhat.com,
       cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: move gfs2 tracepoints to inclue/trace/events dir
Message-ID: <20091012100926.GA15777@elte.hu>
References: <20091009160115.GA2647@redhat.com> <20091009234555.GA28257@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091009234555.GA28257@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> On Fri, Oct 09, 2009 at 12:01:16PM -0400, Jason Baron wrote:
> > hi,
> > 
> > I'd like to move the gfs2 tracepoints to the the common
> > include/trace/events directory along with all of the other trace events.
> > It makes understanding what tracepoints are available easier, and I see
> > no reason why gfs2 should be different. For example, 'ext4.h' is already
> > in the include/trace/events directory.
> 
> Folks, no.  Drivers and filesystems should be as self-contained as 
> possible.  include/trace/ is an extremly bad idea for everything 
> that's not actually global kernel functionality.  There's a reason all 
> other fs headers have moved out of include/linux, too.

Tracing is special though - having global visibility of different 
tracepoints in one place helps keeping the set of tracepoints more 
consistent.

Self-contained tracepoints are fine too, but only as a second-tier 
choice for out-of-tree code or for subsystems that prefer that.

	Ingo
