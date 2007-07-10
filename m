Return-Path: <linux-kernel-owner+w=401wt.eu-S1763094AbXGJWDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763094AbXGJWDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 18:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758357AbXGJWDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 18:03:12 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:60389 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756659AbXGJWDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 18:03:11 -0400
Date: Tue, 10 Jul 2007 18:03:10 -0400
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] LinuxPPS (with new syscalls API) - new version
Message-ID: <20070710220310.GI31193@csclub.uwaterloo.ca>
References: <1183117082.1170.308.camel@pmac.infradead.org> <20070629150813.GM13886@enneenne.com> <1183132548.1170.360.camel@pmac.infradead.org> <20070629163422.GP13886@enneenne.com> <1183135253.17622.5.camel@shinybook.infradead.org> <20070630171340.GT13886@enneenne.com> <20070701171325.29d8b184.sfr@canb.auug.org.au> <20070701192441.GW13886@enneenne.com> <20070710160151.GB31195@csclub.uwaterloo.ca> <20070710163625.GH32503@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710163625.GH32503@enneenne.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 06:36:25PM +0200, Rodolfo Giometti wrote:
> Sorry I wrote wrong. I meant __u32.
> 
> I can use __u64 for seconds but doing this there could be problems for
> 32 bits platforms? =:-o

32bit platforms can still work with 64bit values, they may just not be
quite as efficient about it.

After all we support files with more than 2^32 bytes in them, so the
file access structures must have more than 32bit values in them.

--
Len Sorensen
