Return-Path: <linux-kernel-owner+w=401wt.eu-S1754288AbXEAWfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbXEAWfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 18:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754632AbXEAWfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 18:35:24 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:63573 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288AbXEAWfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 18:35:23 -0400
Date: Tue, 1 May 2007 15:34:40 -0700
From: Bill Irwin <bill.irwin@oracle.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Ulrich Drepper <drepper@gmail.com>, Bill Irwin <bill.irwin@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org,
       wli@holomorphy.com
Subject: Re: per-thread rusage
Message-ID: <20070501223440.GT26598@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Theodore Tso <tytso@mit.edu>, Ulrich Drepper <drepper@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org
References: <20070404172931.GM2986@holomorphy.com> <20070404194829.1a93d8fd.dada1@cosmosbay.com> <20070404181050.GN2986@holomorphy.com> <20070409165315.4704021f.akpm@linux-foundation.org> <20070410004201.GA2986@holomorphy.com> <20070501172937.GQ26598@holomorphy.com> <a36005b50705011139p361dbc46ube0da5e42955f8b0@mail.gmail.com> <20070501202456.GR26598@holomorphy.com> <a36005b50705011510k4cd7873dr3fb8206c0f107169@mail.gmail.com> <20070501222724.GG26093@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070501222724.GG26093@thunk.org>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 06:27:24PM -0400, Theodore Tso wrote:
> 	There are two ways of implementing this.  One is to have the
> JVM periodically poll using a pthread_getrusage() interface.  A better
> choice might be some kind of per-thread CPU limit, that would result
> in a thread-specific SIGXCPU signal.  But there are no interfaces
> today that do anything like this.
> 	Do you have any thoughts or preferences about how this might
> be done, if we tried to about doing something like a per-thread
> SIGXCPU functionality?  If not, pthread_getrusage() might be
> sufficient, if not the most efficient way of doing things.

I just so happen to think we should implement a variety of CPU resource
limits beyond what we now do, so this, too, interests me.


-- wli
