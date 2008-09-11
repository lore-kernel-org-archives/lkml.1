Return-Path: <linux-kernel-owner+w=401wt.eu-S1754867AbYIKQAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbYIKQAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 12:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYIKP7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 11:59:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751986AbYIKP7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 11:59:54 -0400
Date: Thu, 11 Sep 2008 08:57:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frans Pop <elendil@planet.nl>
cc: David Woodhouse <dwmw2@infradead.org>, davem@davemloft.net, jeffm@suse.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
In-Reply-To: <200809111749.40204.elendil@planet.nl>
Message-ID: <alpine.LFD.1.10.0809110852460.3384@nehalem.linux-foundation.org>
References: <48C68507.6000609@suse.com> <200809111725.01511.elendil@planet.nl> <1221147068.8593.31.camel@macbook.infradead.org> <200809111749.40204.elendil@planet.nl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 11 Sep 2008, Frans Pop wrote:
> 
> Just keep on ignoring current issues.

Aren't _you_ the one who are ignoring current issues?

The fact is, _currently_ everybody looks in /lib/firmware. The fact is, 
most people don't want millions of copies of the firmware (one copy for 
each kernel they compile - think about those of us who compile kernels 
every day).

I actually like a release-specific firmware directory, but I think it's 
the *vendor* kernel that should do it, not the normal kernel. The _vendor_ 
should put its firmware files in some vendor-specific place, and then add 
that to the end of the firmware loading path. 

Notice? The vendor can do that. The generic kernel can NOT - since the 
generic kernel cannot impact the firmware loading paths of all the various 
distros. 

So all of the noise in this whole discussion has been totally inane and 
idiotic. 

		Linus
