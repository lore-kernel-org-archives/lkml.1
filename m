Return-Path: <linux-kernel-owner+w=401wt.eu-S1752736AbZJYHRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbZJYHRl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 03:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbZJYHRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 03:17:40 -0400
Received: from verein.lst.de ([213.95.11.210]:33134 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374AbZJYHRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 03:17:40 -0400
Date: Sun, 25 Oct 2009 08:17:09 +0100
From: Christoph Hellwig <hch@lst.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@lst.de>, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: perf trace errors
Message-ID: <20091025071708.GA16936@lst.de>
References: <20091011025441.GA18152@lst.de> <20091016083242.GA11174@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091016083242.GA11174@elte.hu>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 16, 2009 at 10:32:42AM +0200, Ingo Molnar wrote:
> FYI, these bugs are fixed in latest -tip, your testcase works for me:

> Mind checking whether it works for you?

Yes, it works on -tip, but not yet on mainline.  What still doesn't
work yet on -tip either is printing of dynamic strings in some events,
e.g.:

       kjournald-1105  [000]   643.002702: block_rq_complete: 253,0 W () 2283224

