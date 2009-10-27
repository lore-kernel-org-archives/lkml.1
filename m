Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbZJ0HaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbZJ0HaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 03:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407AbZJ0HaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 03:30:06 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:59081 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbZJ0HaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 03:30:05 -0400
Message-ID: <4AE6A16F.4020002@gmail.com>
Date: Tue, 27 Oct 2009 08:29:51 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Stephen Hemminger <stephen.hemminger@vyatta.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Octavian Purdila <opurdila@ixiacom.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] dcache: better name hash function
References: <19864844.24581256620784317.JavaMail.root@tahiti.vyatta.com> <4AE68E23.20205@gmail.com> <4AE69829.9070207@gmail.com>
In-Reply-To: <4AE69829.9070207@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 27 Oct 2009 08:29:53 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet a écrit :
> 
> 
> 511 value on 64bit, and 1023 on 32bit arches are nice because
> hashsz * sizeof(pointer) <= 4096, wasting space for one pointer only.
> 
> Conclusion : jhash and 511/1023 hashsize for netdevices,
> no divides, only one multiply for the fold.

Just forget about 511 & 1023, as power of two works too.

-> 512 & 1024 + jhash

Guess what, David already said this :)
