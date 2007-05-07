Return-Path: <linux-kernel-owner+w=401wt.eu-S934431AbXEGR3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934431AbXEGR3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 13:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965972AbXEGR3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 13:29:18 -0400
Received: from holomorphy.com ([66.93.40.71]:51460 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934329AbXEGR3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 13:29:17 -0400
Date: Mon, 7 May 2007 10:29:26 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, David Chinner <dgc@sgi.com>,
       Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070507172926.GD19966@holomorphy.com>
References: <20070427000403.6013d1fa.akpm@linux-foundation.org> <20070427080321.GG32602149@melbourne.sgi.com> <20070427014849.41f383f7.akpm@linux-foundation.org> <20070427164535.GH24852@thunk.org> <m1abwku30d.fsf@ebiederm.dsl.xmission.com> <20070507042925.GT32602149@melbourne.sgi.com> <m1tzupkzmw.fsf@ebiederm.dsl.xmission.com> <20070507052729.GV32602149@melbourne.sgi.com> <m17irlkubc.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0705070901400.4290@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705070901400.4290@schroedinger.engr.sgi.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2007, Eric W. Biederman wrote:
>> Yes, instead of having to redesign the interface between the
>> fs and the page cache for those filesystems that handle large
>> blocks we instead need to redesign significant parts of the VM interface.
>> Shift the redesign work to another group of people and call it a trivial.

On Mon, May 07, 2007 at 09:06:05AM -0700, Christoph Lameter wrote:
> To some extend that is true. But then there will then also be additional 
> gain: We can likely get the VM to handle larger pages too which may get 
> rid of hugetlb fs etc. The work is pretty straightforward: No locking 
> changes f.e. So hardly a redesign. I think the crucial point is the 
> antifrag/defrag issue if we want to generalize it.

Sadly, a backward compatibility stub must be retained in perpetuity.
It should be able to be reduced to the point it doesn't need its own
dedicated source files or config options, but it'll need something to
deal with the arch code.


-- wli
