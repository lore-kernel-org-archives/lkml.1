Return-Path: <linux-kernel-owner+w=401wt.eu-S932985AbXFEPf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985AbXFEPf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 11:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764846AbXFEPfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 11:35:11 -0400
Received: from waste.org ([66.93.16.53]:40289 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763597AbXFEPfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 11:35:09 -0400
Date: Tue, 5 Jun 2007 10:34:55 -0500
From: Matt Mackall <mpm@selenic.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 4/6] lguest don't signal like crazy, use LHREQ_BREAK command
Message-ID: <20070605153455.GW11115@waste.org>
References: <1181055308.14054.36.camel@localhost.localdomain> <1181055396.14054.38.camel@localhost.localdomain> <1181055483.14054.40.camel@localhost.localdomain> <1181055606.14054.43.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181055606.14054.43.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 01:00:06AM +1000, Rusty Russell wrote:
> We currently use a "waker" process: a child of the launcher which
> selects() on the incoming file descriptors.  It sends a SIGUSR1 to the
> launcher whenever select() returns to kick the launcher out of the
> kernel.

If I break out of lguest with three ctrl-Cs, this leaves one of the
lguest processes running with /dev/lguest held open.

-- 
Mathematics is the supreme nostalgia of our time.
