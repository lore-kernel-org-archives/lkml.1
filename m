Return-Path: <linux-kernel-owner+w=401wt.eu-S935946AbZAOWy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935946AbZAOWy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:54:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935698AbZAOWYC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:24:02 -0500
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:51343 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935702AbZAOWX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:23:59 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAOhEb0l5LBUR/2dsb2JhbADPDIVx
X-IronPort-AV: E=Sophos;i="4.37,272,1231075800"; 
   d="scan'208";a="283744915"
Date: Fri, 16 Jan 2009 09:23:54 +1100
From: Dave Chinner <david@fromorbit.com>
To: wk <handygewinnspiel@gmx.de>
Cc: Chris Mason <chris.mason@oracle.com>, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>, rjw@sisk.pl, HWerner4@gmx.de,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mchehab@infradead.org
Subject: Re: [linux-dvb] compiling on 2.6.28 broken?
Message-ID: <20090115222354.GG8071@disturbed>
Mail-Followup-To: wk <handygewinnspiel@gmx.de>,
	Chris Mason <chris.mason@oracle.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Andrew Morton <akpm@linux-foundation.org>, rjw@sisk.pl,
	HWerner4@gmx.de, viro@zeniv.linux.org.uk,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	mchehab@infradead.org
References: <20090112162337.318dd61d.akpm@linux-foundation.org> <20090113184755.87720@gmx.net> <20090113105947.9e774b69.akpm@linux-foundation.org> <20090113191757.74290@gmx.net> <20090113113700.776a94b5.akpm@linux-foundation.org> <20090113203843.GJ29283@parisc-linux.org> <1231957750.8269.28.camel@think.oraclecorp.com> <496E56EB.2030301@gmx.de> <20090114223016.GY8071@disturbed> <496F9174.5080907@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496F9174.5080907@gmx.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 08:41:40PM +0100, wk wrote:
> Dave Chinner wrote:
>> It's obviously the regression fixed by:
>>
>> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs.git;a=commit;h=15440319767942a363f282d6585303d3d75088ba
>>
>> It needs to be pushed to Linus, then into 2.6.28-stable.
>
> Yes, that solves the problems as expected. But may i kindly ask the xfs  
> fs developers to put some more readable patch here,
> so that its better understandable by looking at the source code? I think  
> some macro would be better here, for example i used
>
> #define TRUNC_TO_SIGNED32(x) (x & 0x7FFFFFFF)
>
> inside xfs.h and replaced all "foo & 0x7fffffff" with  
> "TRUNC_TO_SIGNED32(foo)".

>From the commit description:

"The patch below is a dumb version of just putting back the masking,
 to make sure we have the same behavior as in 2.6.27 and earlier.

 I will work on a better and cleaner fix for 2.6.30."

And in more detail, read the review thread:

http://oss.sgi.com/archives/xfs/2008-12/msg01168.html

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
