Return-Path: <linux-kernel-owner+w=401wt.eu-S1757239AbZA3Wh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbZA3Wh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 17:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754597AbZA3WhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 17:37:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752503AbZA3WhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 17:37:09 -0500
Date: Fri, 30 Jan 2009 14:36:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Parag Warudkar <parag.lkml@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matt Carlson <mcarlson@broadcom.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.29-rc3: tg3 dead after resume
In-Reply-To: <alpine.DEB.2.00.0901301730230.6574@parag-desktop>
Message-ID: <alpine.LFD.2.00.0901301436050.3150@localhost.localdomain>
References: <alpine.DEB.2.00.0901281858380.5048@parag-desktop> <200901300003.38550.rjw@sisk.pl> <20090129234127.GA14023@xw6200.broadcom.net> <200901300110.56533.rjw@sisk.pl> <alpine.DEB.2.00.0901301730230.6574@parag-desktop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 30 Jan 2009, Parag Warudkar wrote:
> 
> BTW, I applied the patch on top of the one Matt gave earlier.
> Machine booted with original tg3 which I rmmod'ed and then insmod'ed the 
> new one (with Matt's and Rafael's patch) and then attempted a 
> suspend-resume.
> 
> Is there a reason to try fresh boot with patched tg3 and without 
> loading old module - I guess I will try that one later as well.

As long as you didn't suspend/resume with the old module loaded, it really 
shouldn't matter.

			Linus
