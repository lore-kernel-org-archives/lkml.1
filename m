Return-Path: <linux-kernel-owner+w=401wt.eu-S1753560AbXH0H52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbXH0H52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 03:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbXH0H5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 03:57:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44599 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751855AbXH0H5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 03:57:20 -0400
Date: Mon, 27 Aug 2007 00:57:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: giggz <giggzounet@gmail.com>
Cc: linux-kernel@vger.kernel.org, Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: PROBLEM : On a laptop Aopen 1556 or 1557 my integrated
 card-reader doesn't work.
Message-Id: <20070827005710.b77ab643.akpm@linux-foundation.org>
In-Reply-To: <46C068FB.1040200@gmail.com>
References: <46C068FB.1040200@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007 16:21:47 +0200 giggz <giggzounet@gmail.com> wrote:

> My mail is a little big. In order not to be blocked I try to attach it.
> 
> Regards,
> Guillaume
> 
> 
> [bug_kernel.txt  text/plain (29.5KB)]
> 
> [1.] One line summary of the problem:
> 
> On a laptop Aopen 1556 or 1557 my integrated card-reader doesn't work.

No responses, huh?

> [2.] Full description of the problem/report:
> 
> The card-reader of my laptop (Aopen 1556 or 1557) has never work. I'm under Debian unstable, but I have tested others distros through live-cd and it doesn't work too.
> 
> [3.] Keywords (i.e., modules, networking, kernel):
> 
> kernel; card-reader; sd-card; pcmcia
> 
> [4.] Kernel information
> [4.1.] Kernel version (from /proc/version):
> 
> Linux version 2.6.22.2-1 (giggz@debian) (gcc version 4.1.3 20070718 (prerelease) (Debian 4.1.2-14)) #1 PREEMPT Fri Aug 10 10:42:01 CEST 2007
> 
> [4.2.] Kernel .config file:

I don't even know which subsystem is supposed to handle that device. 
Perhaps someone can tell us.  It's a Secure Digital card slot?  I think the
MMC subsystem can handle some types SD cards, but not all?

Perhaps Pierre can clue us in?

You raised a bugzilla report for this, I believe?
