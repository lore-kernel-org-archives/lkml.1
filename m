Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbXEGGtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbXEGGtA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 02:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbXEGGtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 02:49:00 -0400
Received: from holomorphy.com ([66.93.40.71]:37238 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084AbXEGGtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 02:49:00 -0400
Date: Sun, 6 May 2007 23:49:25 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Chinner <dgc@sgi.com>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>, clameter@sgi.com,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070507064925.GB19966@holomorphy.com>
References: <20070427060921.GA77450368@melbourne.sgi.com> <20070427000403.6013d1fa.akpm@linux-foundation.org> <20070427080321.GG32602149@melbourne.sgi.com> <20070427014849.41f383f7.akpm@linux-foundation.org> <20070427164535.GH24852@thunk.org> <m1abwku30d.fsf@ebiederm.dsl.xmission.com> <20070507042925.GT32602149@melbourne.sgi.com> <m1tzupkzmw.fsf@ebiederm.dsl.xmission.com> <20070507052729.GV32602149@melbourne.sgi.com> <m17irlkubc.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m17irlkubc.fsf@ebiederm.dsl.xmission.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner <dgc@sgi.com> writes:
>> Right - so how do we efficiently  manipulate data inside a large
>> block that spans multiple discontigous pages if we don't vmap
>> it?

On Mon, May 07, 2007 at 12:43:19AM -0600, Eric W. Biederman wrote:
> You don't manipulate data except for copy_from_user, copy_to_user.
> That is easy comparatively to deal with, and certainly doesn't
> need vmap.
> Meta-data may be trickier, but a lot of that depends on your
> individual filesystem and how it organizes it's meta-data.

I wonder what happened to my pagearray patches.


-- wli
