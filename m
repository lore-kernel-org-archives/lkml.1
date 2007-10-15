Return-Path: <linux-kernel-owner+w=401wt.eu-S933526AbXJOSVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933526AbXJOSVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765698AbXJOSV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:21:27 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1916 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764824AbXJOSV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:21:26 -0400
Date: Mon, 15 Oct 2007 19:21:18 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: "Mike D. Day" <ncmike@us.ibm.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] checkpatch: Fix line number reporting
Message-ID: <20071015182118.GA4459@shadowen.org>
References: <20071012193751.GA31579@shadowen.org> <200710131835.l9DIZCYp030867@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710131835.l9DIZCYp030867@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2007 at 02:35:12PM -0400, Erez Zadok wrote:
> In message <20071012193751.GA31579@shadowen.org>, Andy Whitcroft writes:
> > On Fri, Oct 12, 2007 at 03:26:54PM -0400, Mike D. Day wrote:
> > > Fix line number reporting when checking source files (as opposed to
> > > patches)
> > > 
> > > Signed-off-by: Mike D. Day <ncmike@us.ibm.com>
> > 
> > Sorry you've had to fix this about 4 times, mostly because of ongoing
> > changes, and slow replication getting in the way.  I've applied this
> > and you should find it in -next when replication hits.  md5sum is
> > below of the version with it in, so you can make sure you've got
> > the right one.
> > 
> > 54f053c50265e44a6041e3147dc66a69  checkpatch.pl
> > 
> > -apw
> 
> Andy, I've tested the --emacs feature in the above latest
> checkpatch.pl-next.  Below is a patch that completes the functionality of
> the --emacs option: it ensures that only the cc-style error messages are
> printed, no extra context lines or caret lines, no extra newlines, etc.
> Although this patch changes every call to a message-producing function, it
> is a trivial change, and I believe it's the cleanest way to handle the
> separation between the terse cc-style messages and the verbose default
> messages.  With this patch, I can finally test a single source file as
> follows:
> 
> $ ./scripts/checkpatch.pl -q -q --emacs --file path/name/to/file

Ok I don't understand why the rest of the lines are a problem?  At least
with emacs the extra context lines are just ignored right?  Are you
trying to use this as a summary?

-apw
