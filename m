Return-Path: <linux-kernel-owner+w=401wt.eu-S1757626AbZABJts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626AbZABJts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 04:49:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756248AbZABJti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 04:49:38 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48169 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754514AbZABJth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 04:49:37 -0500
Date: Fri, 2 Jan 2009 04:49:34 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Message-ID: <20090102094934.GB17841@infradead.org>
References: <200901020207.30359.rob@landley.net> <200901021026.37905.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901021026.37905.a.miskiewicz@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 10:26:37AM +0100, Arkadiusz Miskiewicz wrote:
> On Friday 02 of January 2009, Rob Landley wrote:
> > Before 2.6.25 (specifically git bdc807871d58285737d50dc6163d0feb72cb0dc2 )
> > building a Linux kernel never required perl to be installed on the build
> > system.  (Various development and debugging scripts were written in perl
> > and python and such, but they weren't involved in actually building a
> > kernel.) Building a kernel before 2.6.25 could be done with a minimal
> > system built from gcc, binutils, bash, make, busybox, uClibc, and the Linux
> > kernel, and nothing else.
> 
> And now bash is going to be required... while some distros don't need/have 
> bash. /bin/sh should be enough.

*nod*  bash is in many ways a worse requirement than perl.  strict posix
/bin/sh + awk + sed would be nicest, but if that's too much work perl
seems reasonable.

