Return-Path: <linux-kernel-owner+w=401wt.eu-S966028AbXDJAmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966028AbXDJAmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 20:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966031AbXDJAmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 20:42:55 -0400
Received: from holomorphy.com ([66.93.40.71]:58636 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966028AbXDJAmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 20:42:54 -0400
Date: Mon, 9 Apr 2007 17:42:01 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org
Subject: Re: per-thread rusage
Message-ID: <20070410004201.GA2986@holomorphy.com>
References: <20070404172931.GM2986@holomorphy.com> <20070404194829.1a93d8fd.dada1@cosmosbay.com> <20070404181050.GN2986@holomorphy.com> <20070409165315.4704021f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070409165315.4704021f.akpm@linux-foundation.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007 11:10:50 -0700 William Lee Irwin III <wli@holomorphy.com> wrote:
>> Respun vs. 2.6.21-rc5-mm4, still untested. Also...
>> Signed-off-by: William Irwin <bill.irwin@oracle.com>
[...]


On Mon, Apr 09, 2007 at 04:53:15PM -0700, Andrew Morton wrote:
> Seems sane.  Could we please get it tested and get a full description in
> place?  Something which provides enough detail for the manpage maintainers.
> Also, a quick comparison between Linux's RUSAGE_THREAD and $other-os's
> implementations would reduce the possibility of silly, cast-in-stone
> incompatabilities.

The latter is the more serious of the two. I'll go about investigating
that as the primary task here. Testing and a more verbose patch
description are clearly very little work.

General maintenance-relevant commentary: This patch arose from an
observation of a lacuna in the API. There are no bugs or apps broken
awaiting this as a fix, so it's not needed by 2.6.22 or otherwise
urgently. My use for it is report generation in VM (and possibly other)
testcases. The ack-in-concept is good enough for me to go about
sweeping up the OS/standards compatibility, testing, and documentation
issues in the near future prior to resubmission.


-- wli
