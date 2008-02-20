Return-Path: <linux-kernel-owner+w=401wt.eu-S1765111AbYBTSTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765111AbYBTSTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 13:19:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755080AbYBTSTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 13:19:30 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1369 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754154AbYBTST3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 13:19:29 -0500
Date: Wed, 20 Feb 2008 18:19:12 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, John Stoffel <john@stoffel.org>,
       Andi Kleen <andi@firstfloor.org>, akpm@osdl.org, torvalds@osdl.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] Document huge memory/cache overhead of memory controller in Kconfig
Message-ID: <20080220181911.GA4760@ucw.cz>
References: <20080220122338.GA4352@basil.nowhere.org> <47BC2275.4060900@linux.vnet.ibm.com> <18364.16552.455371.242369@stoffel.org> <47BC4554.10304@linux.vnet.ibm.com> <Pine.LNX.4.64.0802201647060.26109@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802201647060.26109@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> I know this is a pedantic comment, but why the heck is it called such
> >> a generic term as "Memory Controller" which doesn't give any
> >> indication of what it does.
> >> 
> >> Shouldn't it be something like "Memory Quota Controller", or "Memory
> >> Limits Controller"?
> >
> >It's called the memory controller since it controls the amount of
> >memory that a user can allocate (via limits). The generic term for
> >any resource manager plugged into cgroups is a controller.
> 
> For ordinary desktop people, memory controller is what developers
> know as MMU or sometimes even some other mysterious piece of silicon
> inside the heavy box.

Actually I'd guess 'memory controller' == 'DRAM controller' == part of
northbridge that talks to DRAM.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
