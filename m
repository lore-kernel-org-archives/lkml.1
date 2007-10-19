Return-Path: <linux-kernel-owner+w=401wt.eu-S966155AbXJSHWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966155AbXJSHWB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 03:22:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbXJSHVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 03:21:54 -0400
Received: from dtp.xs4all.nl ([80.126.206.180]:52147 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756237AbXJSHVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 03:21:53 -0400
Date: Fri, 19 Oct 2007 09:21:50 +0200
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: Rob Landley <rob@landley.net>
Cc: Rogier Wolff <R.E.Wolff@BitWizard.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Theodore Tso <tytso@mit.edu>,
       James Bottomley <James.Bottomley@steeleye.com>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Nick Piggin <piggin@cyberone.com.au>
Subject: Re: OOM killer gripe (was Re: What still uses the block layer?)
Message-ID: <20071019072150.GA18307@bitwizard.nl>
References: <200710112011.22000.rob@landley.net> <200710161734.15880.nickpiggin@yahoo.com.au> <20071018130048.GA25084@bitwizard.nl> <200710190149.31962.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710190149.31962.rob@landley.net>
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2007 at 01:49:31AM -0500, Rob Landley wrote:
> On Thursday 18 October 2007 8:00:49 am Rogier Wolff wrote:
> > So... IMHO, it would be useful to implement something that pages out
> > chunks of memory larger than a single hardware page. This would reduce
> > the size of the memory management tables (*), as well as improve disk
> > throughput if things DO come to paging....
> 
> I believe that was more or less the topic of this paper:
>   http://kernel.org/doc/ols/2006/ols2006v2-pages-73-78.pdf

Not really. They are talking about doing this for the page
cache. That's where filesystem files are cached in memory. I'm talking
about the memory that programs use while they are running.

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
