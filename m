Return-Path: <linux-kernel-owner+w=401wt.eu-S1753515AbZAaVfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbZAaVfc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 16:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbZAaVfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 16:35:24 -0500
Received: from fifo99.com ([67.223.236.141]:50358 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbZAaVfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 16:35:24 -0500
Subject: Re: checkpatch.pl is getting too slow
From: Daniel Walker <dwalker@fifo99.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20090131210220.GA25811@shadowen.org>
References: <20090131185507.GA3280@kroah.com>
	 <20090131210220.GA25811@shadowen.org>
Content-Type: text/plain
Date: Sat, 31 Jan 2009 13:35:19 -0800
Message-Id: <1233437719.5903.33.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-31 at 21:02 +0000, Andy Whitcroft wrote:
> On Sat, Jan 31, 2009 at 10:55:07AM -0800, Greg KH wrote:
> > Hi Andy,
> > 
> > I've noticed that checkpatch.pl is getting slower and slower when run on
> > a whole file, but yesterday I realized that it now is pretty much
> > unusable:
> > 
> > $ time ./scripts/checkpatch.pl --file drivers/staging/uc2322/aten2011.c
> > 
> > <snip>
> > total: 168 errors, 126 warnings, 3939 lines checked
> > 
> > drivers/staging/uc2322/aten2011.c has style problems, please review.  If any of these errors
> > are false positives report them to the maintainer, see
> > CHECKPATCH in MAINTAINERS.
> > 
> > real	8m7.924s
> > user	8m7.058s
> > sys	0m0.116s
> 
> That is scarey indeed.  Something is very wrong in there if it went back
> to a more reasonable 10's of seconds with a few patches.  I will have a
> look at the file you attached and see what I can find.
> 
> Thanks for the heads up.

The way your doing updates makes bisecting this code way too difficult..
I bisected this down to the commit for version 0.15 , but if you had all
the 0.15 patches as discrete git commits I could have actually found the
specific patch causing the problem ..

Could you start doing one fix or change per git commit?

Daniel

