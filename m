Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499AbYKQRgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbYKQRgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 12:36:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbYKQRgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 12:36:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752261AbYKQRgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 12:36:12 -0500
Date: Mon, 17 Nov 2008 09:35:25 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [PATCH] vmscan: fix get_scan_ratio comment
In-Reply-To: <4921A706.9030501@redhat.com>
Message-ID: <alpine.LFD.2.00.0811170932390.3468@nehalem.linux-foundation.org>
References: <20081115181748.3410.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081115210039.537f59f5.akpm@linux-foundation.org> <alpine.LFD.2.00.0811161013270.3468@nehalem.linux-foundation.org> <49208E9A.5080801@redhat.com> <20081116204720.1b8cbe18.akpm@linux-foundation.org>
 <20081117153012.51ece88f.kamezawa.hiroyu@jp.fujitsu.com> <2f11576a0811162239w58555c6dq8a61ec184b22bd52@mail.gmail.com> <20081117155417.5cc63907.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LFD.2.00.0811170802010.3468@nehalem.linux-foundation.org>
 <alpine.LFD.2.00.0811170830320.3468@nehalem.linux-foundation.org> <4921A1AF.1070909@redhat.com> <alpine.LFD.2.00.0811170904160.3468@nehalem.linux-foundation.org> <4921A706.9030501@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Grr. Don't use attachments. Now I can't sanely reply and quote things 
with a sane default setting (yes, I could set "include attachements in 
reply", but that is _not_ a sane default setting, and anybody who claims 
it is is a moron).

Why don't people learn?

Anyway, without quoting, the thing is - your fix isn't any better. The 
more interesting part is how the fractions get combined, and that is 
indeed approximately "anon% = anon / (anon + file)".

So you in many ways made the comment worse. It wasn't good before, but 
it's still not good, and now it comments on the part that isn't even 
interesting (ie it comments the _trivial_ fractional part)

		Linus
