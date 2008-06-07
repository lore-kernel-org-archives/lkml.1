Return-Path: <linux-kernel-owner+w=401wt.eu-S1759301AbYFGWT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301AbYFGWT4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 18:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbYFGWTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 18:19:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35723 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbYFGWTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 18:19:47 -0400
Message-ID: <484B02CF.6000606@kernel.org>
Date: Sat, 07 Jun 2008 14:51:11 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Marcin Krol <hawk@pld-linux.org>, Nick Piggin <npiggin@suse.de>
Subject: Re: [patch 21/50] brd: dont show ramdisks in /proc/partitions
References: <20080607010215.358296706@sous-sol.org> <20080607010610.796754560@sous-sol.org>
In-Reply-To: <20080607010610.796754560@sous-sol.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
 > From: Marcin Krol <hawk@pld-linux.org>
 >
> I also think that someone somewhere (long time ago) excluded ramdisks from
> /proc/partitions for good reasons.  It is possible that now such new
> "feature" is harmless, but I think there are more chances that someone
> will say "hey, /proc/partitions has changed, now my software doesn't work"
> then "hey where did my new 2.6.25 feature go".  nbd devices are also
> excluded, maybe for very same (unknown to me) reasons.

This seems a bit like cargo cult programming to me.  If there isn't a 
known, good, reason to revert this behaviour change, I would consider it 
a bugfix, not a regression.

	-hpa
