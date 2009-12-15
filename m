Return-Path: <linux-kernel-owner+w=401wt.eu-S1757734AbZLOBrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734AbZLOBrf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 20:47:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756726AbZLOBre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 20:47:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59393 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755411AbZLOBrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 20:47:33 -0500
Date: Mon, 14 Dec 2009 17:47:14 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Greg KH <greg@kroah.com>
cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB patches for 2.6.33-git
In-Reply-To: <alpine.LFD.2.00.0912141658290.14385@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0912141744360.14385@localhost.localdomain>
References: <20091211212646.GB6624@kroah.com> <alpine.LFD.2.00.0912141635000.14385@localhost.localdomain> <20091215005216.GA9309@kroah.com> <alpine.LFD.2.00.0912141658290.14385@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Dec 2009, Linus Torvalds wrote:
> 
> Will continue to bisect.

So far:

	Good: d71cb81af3817193bc605de061da0499934263a6
	Bad: 6bd03e7b9d0f70928f9cd793326c28e4e08ffc96

so it's definitely from that USB merge (unless it comes and goes 
intermittently and my bisect is not reliable, but the 
fact that I've bisected down to the USB merge makes it at least _look_ 
plausible).

Not surprising, and there's 85 commits in between those points, so I'll 
have to do 7 more bisection points.

			Linus
