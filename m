Return-Path: <linux-kernel-owner+w=401wt.eu-S1759421AbXGJQB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421AbXGJQB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 12:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbXGJQBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 12:01:52 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:55427 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752302AbXGJQBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 12:01:52 -0400
Date: Tue, 10 Jul 2007 12:01:51 -0400
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] LinuxPPS (with new syscalls API) - new version
Message-ID: <20070710160151.GB31195@csclub.uwaterloo.ca>
References: <1183031060.1170.145.camel@pmac.infradead.org> <20070628161450.GD13886@enneenne.com> <1183117082.1170.308.camel@pmac.infradead.org> <20070629150813.GM13886@enneenne.com> <1183132548.1170.360.camel@pmac.infradead.org> <20070629163422.GP13886@enneenne.com> <1183135253.17622.5.camel@shinybook.infradead.org> <20070630171340.GT13886@enneenne.com> <20070701171325.29d8b184.sfr@canb.auug.org.au> <20070701192441.GW13886@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070701192441.GW13886@enneenne.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 01, 2007 at 09:24:41PM +0200, Rodolfo Giometti wrote:
>     struct pps_timedata_s {
>        __32 sec;
>        __32 nsec;
>     }
> 
> Ok? I think 32 bits are enought for keeping seconds... :)

You want to purposely define an API that will break in 23 years (or is
that 83 years since you made it unsigned potentially)?  Why not 64bit
for seconds and 32bit for nsec.  That should cover it for long enough.
When the unix time format was created 37 years ago, I could see thinking
32bit seemed reasonable, but why do it now.  We have ram enough for
64bits.

--
Len Sorensen
