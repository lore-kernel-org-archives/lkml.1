Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbYFIUHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbYFIUHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 16:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbYFIUHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 16:07:30 -0400
Received: from 1wt.eu ([62.212.114.60]:1651 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082AbYFIUHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 16:07:24 -0400
Date: Mon, 9 Jun 2008 21:49:29 +0200
From: Willy Tarreau <w@1wt.eu>
To: Chris Wright <chrisw@sous-sol.org>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Marcin Krol <hawk@pld-linux.org>,
       jejb@kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, torvalds@linux-foundation.org,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>, Nick Piggin <npiggin@suse.de>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, akpm@linux-foundation.org,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 21/50] brd: dont show ramdisks in /proc/partitions
Message-ID: <20080609194928.GM5609@1wt.eu>
References: <20080607010215.358296706@sous-sol.org> <20080607010610.796754560@sous-sol.org> <484B02CF.6000606@kernel.org> <20080609170840.GG30402@sequoia.sous-sol.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080609170840.GG30402@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2008 at 10:08:40AM -0700, Chris Wright wrote:
> * H. Peter Anvin (hpa@kernel.org) wrote:
> > This seems a bit like cargo cult programming to me.  If there isn't a 
> > known, good, reason to revert this behaviour change, I would consider it 
> > a bugfix, not a regression.
> 
> We have one /proc/partitions parser that got broken (never saw details
> on how).  I don't care for this change either (esp. since nbd is still
> left out...it's inconsistent).

I also had one of my old install scripts proposing me to choose between
16 ramdisks to install to. Quite bothering in fact. I'm not sure we
really can consider ramdisks as partitions. Also, all of them are listed,
whether they are initialized or not.

In fact, I was glad to see this "fixed" with this patch.

Regards,
willy

