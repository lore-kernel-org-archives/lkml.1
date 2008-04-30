Return-Path: <linux-kernel-owner+w=401wt.eu-S1765484AbYD3W2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765484AbYD3W2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761254AbYD3W2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:28:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40842 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762228AbYD3W2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:28:13 -0400
Message-ID: <4818EA2C.2040507@zytor.com>
Date: Wed, 30 Apr 2008 14:52:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: Slow DOWN, please!!!
References: <20080429.190352.137408408.davem@davemloft.net> <200804302136.58005.rjw@sisk.pl> <20080430131537.1f7a0914.akpm@linux-foundation.org> <alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> The tester base is simply too small.
> 
> Now, if *that* could be improved, that would be wonderful, but I'm not 
> seeing it as very likely.
> 

One thing is that we keep fragmenting the tester base by adding new 
confidence levels: we now have -mm, -next, mainline -git, mainline -rc, 
mainline release, stable, distro testing, and distro release (and some 
distros even have aggressive versus conservative tracks.)  Furthermore, 
thanks to craniorectal immersion on the part of graphics vendors, a lot 
of users have to run proprietary drivers on their "main work" systems, 
which means they can't even test newer releases even if they would dare.

This fragmentation is largely intentional, of course -- everyone can 
pick a risk level appropriate for them -- but it does mean:

a) The lag for a patch to ride through the pipeline is pretty long.
b) The section of people who are going to use the more aggressive trees 
for "real work" testing is going to be small.

	-hpa

