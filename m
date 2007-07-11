Return-Path: <linux-kernel-owner+w=401wt.eu-S1765399AbXGKPZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765399AbXGKPZF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 11:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758790AbXGKPY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 11:24:57 -0400
Received: from [129.97.134.17] ([129.97.134.17]:45062 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758105AbXGKPY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 11:24:56 -0400
Date: Wed, 11 Jul 2007 11:24:55 -0400
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Rodolfo Giometti <giometti@enneenne.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] LinuxPPS (with new syscalls API) - new version
Message-ID: <20070711152455.GK31193@csclub.uwaterloo.ca>
References: <1183031060.1170.145.camel@pmac.infradead.org> <20070701192441.GW13886@enneenne.com> <20070710160151.GB31195@csclub.uwaterloo.ca> <200707110318.49244.zippel@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707110318.49244.zippel@linux-m68k.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 03:18:46AM +0200, Roman Zippel wrote:
> This is really not an API that needs to deal with such large time range.

No one will want to use PPS API to keep accurate time past 2030?  Why
not?  Or should we be forced to invent a new PPS API before then to fix
this one?

Actually, come to think of it, is this passing a current time, or it it
passing an interval since last PPS?  If it is an interval, then yes
never mind, we don't need that many seconds (usually 1 or 2 at most).
For some reason I thought this was for passing the current time of a
stamp.

--
Len Sorensen
