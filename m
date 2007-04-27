Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbXD0H3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbXD0H3E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 03:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbXD0H3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 03:29:03 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35215 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755451AbXD0H3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 03:29:01 -0400
Date: Fri, 27 Apr 2007 00:26:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-Id: <20070427002640.22a71d06.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704270007100.5388@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com>
	<20070426190438.3a856220.akpm@linux-foundation.org>
	<20070427022731.GF65285596@melbourne.sgi.com>
	<20070426195357.597ffd7e.akpm@linux-foundation.org>
	<20070427042046.GI65285596@melbourne.sgi.com>
	<20070426221528.655d79cb.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com>
	<20070426235542.bad7035a.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704270007100.5388@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 00:19:49 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> The page cache handling in the various layers is significantly 
> simplified which reduces maintenance cost.

How on earth can the *addition* of variable pagecache size simplify the
existing code?

What cleanups are in this patchset which cannot be made *without* the
addition of variable pagecache size?

> Dave, where are we with the performance tests?

Well yes.

Do note that if the numbers are good, we also need to look at how generally
useful this work is.  For example, if it only benefits one particular
arguably-crippled present-generation adapter then that of course weakens the
case.
