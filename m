Return-Path: <linux-kernel-owner+w=401wt.eu-S1755032AbXEARap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032AbXEARap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 13:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755035AbXEARap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 13:30:45 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:16059 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032AbXEARao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 13:30:44 -0400
Date: Tue, 1 May 2007 10:29:37 -0700
From: Bill Irwin <bill.irwin@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org
Subject: Re: per-thread rusage
Message-ID: <20070501172937.GQ26598@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org
References: <20070404172931.GM2986@holomorphy.com> <20070404194829.1a93d8fd.dada1@cosmosbay.com> <20070404181050.GN2986@holomorphy.com> <20070409165315.4704021f.akpm@linux-foundation.org> <20070410004201.GA2986@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070410004201.GA2986@holomorphy.com>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2007 at 04:53:15PM -0700, Andrew Morton wrote:
>> Seems sane.  Could we please get it tested and get a full description in
>> place?  Something which provides enough detail for the manpage maintainers.
>> Also, a quick comparison between Linux's RUSAGE_THREAD and $other-os's
>> implementations would reduce the possibility of silly, cast-in-stone
>> incompatabilities.

On Mon, Apr 09, 2007 at 05:42:01PM -0700, William Lee Irwin III wrote:
> The latter is the more serious of the two. I'll go about investigating
> that as the primary task here. Testing and a more verbose patch
> description are clearly very little work.
> General maintenance-relevant commentary: This patch arose from an
> observation of a lacuna in the API. There are no bugs or apps broken
> awaiting this as a fix, so it's not needed by 2.6.22 or otherwise
> urgently. My use for it is report generation in VM (and possibly other)
> testcases. The ack-in-concept is good enough for me to go about
> sweeping up the OS/standards compatibility, testing, and documentation
> issues in the near future prior to resubmission.

A sort of note for me to refer back to when I get the rest of the way
here. AIX does this with getrusage(RUSAGE_THREAD,...), Solaris with
getrusage(RUSAGE_LWP,...), Tru64 and HP-UX seem to lack any obvious
way to do this at all, likewise for MacOS X and the opensource BSD's.


-- wli
