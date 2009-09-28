Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494AbZI1WK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbZI1WK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 18:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753034AbZI1WKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 18:10:24 -0400
Received: from fmmailgate04.web.de ([217.72.192.242]:46496 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbZI1WKT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 18:10:19 -0400
Date: Tue, 29 Sep 2009 00:10:22 +0200
Message-Id: <932321422@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.32-rc1
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1+lK4g54dxNwGkTIi3JRGMWh0t7wuMY1x1mYGlNUKtw+dEWt
 zg4T9HjlvGN8E1WeXQri0XhwH64jbnUeUNEZf7KcvBBFJdc7Uw=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>and as usual that means that the merge window is all over and done with

so, all the "heavy" stuff is in now - but no DRBD ? 




List:       linux-kernel
Subject:    Linux 2.6.32-rc1
From:       Linus Torvalds <torvalds () linux-foundation ! org>
Date:       2009-09-27 22:34:53
Message-ID: alpine.LFD.2.01.0909271511190.3349 () localhost ! localdomain
[Download message RAW]


It's been two weeks (and then some - but with last week being LinuxCon and 
Plumbers conf I extended it by a few days), and as usual that means that 
the merge window is all over and done with. 2.6.32-rc1 is out, so give it 
a whirl.

What can I say? 67% drivers (the bulk of which is from 'staging', but 
there's driver changes all over), 10% firmware, 10% arch updates 
(dominated by arm, but MIPS, POWER, SH and x86 updates are there too, 
along with the new 'SCore' architecture), 5% Documentation, and a random 
smattering of other things (ie the normal filesystem, kernel, networking 
etc updates).

For a change, I don't think we have a single new filesystem this time 
around, but we do have updates to existing ones (ocfs2, btrfs, nfs, nilfs, 
xfs, gfs2, ext4 - you name it).

Some of the more interesting changes (but perhaps that's just me) are some 
of the VM updates (ZERO_PAGE is back!) and the writeback work by Jens and 
others to spread out writeback by backing store. 

Go wild, test it out, and let us know about any regressions you find,

		Linus

______________________________________________________
GRATIS für alle WEB.DE-Nutzer: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://movieflat.web.de

