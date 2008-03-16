Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbYCPX3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbYCPX3D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 19:29:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbYCPX2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 19:28:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47352 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753058AbYCPX2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 19:28:53 -0400
Date: Sun, 16 Mar 2008 16:27:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Anders Eriksson <aeriksson@fastmail.fm>
cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc4 
In-Reply-To: <20080316225921.CAA082DC044@tippex.mynet.homeunix.org>
Message-ID: <alpine.LFD.1.00.0803161618480.3020@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <200803161907.04581.bzolnier@gmail.com> <alpine.LFD.1.00.0803161111000.3020@woody.linux-foundation.org> <200803162054.04757.bzolnier@gmail.com>
 <20080316225921.CAA082DC044@tippex.mynet.homeunix.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 16 Mar 2008, Anders Eriksson wrote:
> 
> rc5 fails with and without that patch.

Can you try to sprinkle printk's around to see where it actually ends up 
stopping?

Since all special commands should now go through the taskfile interface 
(Bartlomiej - correct?), I guess just a printk() at the top of 
do_rw_taskfile() should at least get the ball rolling. Even something that 
just prints out task->data_phase and tf->command would start to unravel at 
least what the last command is before it hangs..

		Linus
