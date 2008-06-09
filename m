Return-Path: <linux-kernel-owner+w=401wt.eu-S1757117AbYFIUzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117AbYFIUzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 16:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbYFIUzC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 16:55:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34452 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbYFIUzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 16:55:00 -0400
Message-ID: <484D9263.2040401@zytor.com>
Date: Mon, 09 Jun 2008 13:28:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Marcin Krol <hawk@pld-linux.org>, jejb@kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, torvalds@linux-foundation.org,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>, Nick Piggin <npiggin@suse.de>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, akpm@linux-foundation.org,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 21/50] brd: dont show ramdisks in	/proc/partitions
References: <20080607010215.358296706@sous-sol.org> <20080607010610.796754560@sous-sol.org> <484B02CF.6000606@kernel.org> <20080609170840.GG30402@sequoia.sous-sol.org>
In-Reply-To: <20080609170840.GG30402@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
> * H. Peter Anvin (hpa@kernel.org) wrote:
>> This seems a bit like cargo cult programming to me.  If there isn't a 
>> known, good, reason to revert this behaviour change, I would consider it 
>> a bugfix, not a regression.
> 
> We have one /proc/partitions parser that got broken (never saw details
> on how).  I don't care for this change either (esp. since nbd is still
> left out...it's inconsistent).
> 
> This is now the upstream behaviour (obvious since it's a -stable
> candidate), and the change was introduced in 2.6.25...I'd actually prefer
> to drop this patch, but there's no good reason to deviate if upstream
> keeps this one.  I can defer while upstream gets revisited, can you
> revisit this upstream?

I had to ask Chris offline what he meant with this... basically, he and 
I both agree that absent hard evidence of malfunction, we should revert 
to 2.6.25 behaviour.

	-hpa

