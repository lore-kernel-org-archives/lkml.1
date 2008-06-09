Return-Path: <linux-kernel-owner+w=401wt.eu-S1757640AbYFIRRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640AbYFIRRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 13:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbYFIRRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 13:17:40 -0400
Received: from sous-sol.org ([216.99.217.87]:46248 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755570AbYFIRRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 13:17:22 -0400
Date: Mon, 9 Jun 2008 10:08:40 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Marcin Krol <hawk@pld-linux.org>,
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
Subject: Re: [stable] [patch 21/50] brd: dont show ramdisks in
	/proc/partitions
Message-ID: <20080609170840.GG30402@sequoia.sous-sol.org>
References: <20080607010215.358296706@sous-sol.org> <20080607010610.796754560@sous-sol.org> <484B02CF.6000606@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484B02CF.6000606@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@kernel.org) wrote:
> This seems a bit like cargo cult programming to me.  If there isn't a 
> known, good, reason to revert this behaviour change, I would consider it 
> a bugfix, not a regression.

We have one /proc/partitions parser that got broken (never saw details
on how).  I don't care for this change either (esp. since nbd is still
left out...it's inconsistent).

This is now the upstream behaviour (obvious since it's a -stable
candidate), and the change was introduced in 2.6.25...I'd actually prefer
to drop this patch, but there's no good reason to deviate if upstream
keeps this one.  I can defer while upstream gets revisited, can you
revisit this upstream?

thanks,
-chris
