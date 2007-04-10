Return-Path: <linux-kernel-owner+w=401wt.eu-S1030197AbXDJBNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030197AbXDJBNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 21:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030201AbXDJBNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 21:13:10 -0400
Received: from holomorphy.com ([66.93.40.71]:34689 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030197AbXDJBNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 21:13:08 -0400
Date: Mon, 9 Apr 2007 18:12:57 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org
Subject: Re: per-thread rusage
Message-ID: <20070410011257.GC2986@holomorphy.com>
References: <20070404172931.GM2986@holomorphy.com> <20070404194829.1a93d8fd.dada1@cosmosbay.com> <20070404181050.GN2986@holomorphy.com> <20070409165315.4704021f.akpm@linux-foundation.org> <20070410004201.GA2986@holomorphy.com> <20070409175352.0474a3c9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070409175352.0474a3c9.akpm@linux-foundation.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Apr 2007 17:42:01 -0700 William Lee Irwin III <wli@holomorphy.com> wrote:
>>  My use for it is report generation in VM (and possibly other)
>> testcases.

On Mon, Apr 09, 2007 at 05:53:52PM -0700, Andrew Morton wrote:
> OK.  The cool kids are using taskstats for this sort of thing now, but I
> note that taskstats is inexplicably missing the context-switch accounting,
> and perhaps other things?

Sounds interesting. I'll poke around there for testcase affairs if I
get moving on them first. I've no sentimental attachment to the rusage
patch, so if taskstats do happen to displace this, I'm not concerned.
(That said, it may still make sense to do this for the purposes of API
compatibility. I'll keep it moving along until it's all decided.)


-- wli
