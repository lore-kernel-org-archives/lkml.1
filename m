Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbZAaVCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbZAaVCd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 16:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbZAaVCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 16:02:24 -0500
Received: from adelie.canonical.com ([91.189.90.139]:49166 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbZAaVCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 16:02:24 -0500
Date: Sat, 31 Jan 2009 21:02:20 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: checkpatch.pl is getting too slow
Message-ID: <20090131210220.GA25811@shadowen.org>
References: <20090131185507.GA3280@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090131185507.GA3280@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 31, 2009 at 10:55:07AM -0800, Greg KH wrote:
> Hi Andy,
> 
> I've noticed that checkpatch.pl is getting slower and slower when run on
> a whole file, but yesterday I realized that it now is pretty much
> unusable:
> 
> $ time ./scripts/checkpatch.pl --file drivers/staging/uc2322/aten2011.c
> 
> <snip>
> total: 168 errors, 126 warnings, 3939 lines checked
> 
> drivers/staging/uc2322/aten2011.c has style problems, please review.  If any of these errors
> are false positives report them to the maintainer, see
> CHECKPATCH in MAINTAINERS.
> 
> real	8m7.924s
> user	8m7.058s
> sys	0m0.116s

That is scarey indeed.  Something is very wrong in there if it went back
to a more reasonable 10's of seconds with a few patches.  I will have a
look at the file you attached and see what I can find.

Thanks for the heads up.

-apw
