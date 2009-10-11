Return-Path: <linux-kernel-owner+w=401wt.eu-S1755690AbZJKMlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbZJKMlV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 08:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbZJKMlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 08:41:20 -0400
Received: from verein.lst.de ([213.95.11.210]:56627 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990AbZJKMlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 08:41:20 -0400
Date: Sun, 11 Oct 2009 14:40:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: perf trace errors
Message-ID: <20091011124030.GA3859@lst.de>
References: <20091011025441.GA18152@lst.de> <20091011121926.GD4901@nowhere>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091011121926.GD4901@nowhere>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 11, 2009 at 02:19:28PM +0200, Frederic Weisbecker wrote:
> Yeah, there are still some trace events that are not well supported
> in perf trace, for now... I'll fix that by the time.

Any idea what is the missing part?  I tried to understand the code but
I haven't even managed to grasp the data structures yet.

The weird thing is that these message seem to come from parsing of
the filters, and a simple trace the whole system trace shouldn't
really have to set any filters anyway, nor should the filters depdend
on what trace point you use.

Note that the in addition to all the block trace points also all my
new xfs tracepoints also give errors from perf trace.  Things tend
to work quite nicely with the ASCII output from the kernel.

