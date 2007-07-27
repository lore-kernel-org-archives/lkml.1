Return-Path: <linux-kernel-owner+w=401wt.eu-S965148AbXG0U37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965148AbXG0U37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 16:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933270AbXG0U3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 16:29:48 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:52507
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934195AbXG0U3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 16:29:46 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Merge the Sonics Silicon Backplane subsystem
Date: Fri, 27 Jul 2007 22:28:01 +0200
User-Agent: KMail/1.9.6
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       bcm43xx-dev@lists.berlios.de, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, Gary Zambrano <zambrano@broadcom.com>
References: <200707271857.24162.mb@bu3sch.de> <200707272143.59551.mb@bu3sch.de> <20070727131249.74330a3d.akpm@linux-foundation.org>
In-Reply-To: <20070727131249.74330a3d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707272228.02152.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 July 2007 22:12:49 Andrew Morton wrote:
> On Fri, 27 Jul 2007 21:43:59 +0200
> Michael Buesch <mb@bu3sch.de> wrote:
> 
> > > Sure, but why is the locking interruptible rather than plain old
> > > mutex_lock()?
> > 
> > Hm, well. We hold this mutex for several seconds, as writing takes
> > this long. So I simply thought it was worth allowing the waiter
> > to interrupt here. If you say that's not an issue, I'll be happy
> > to use mutex_lock() and reduce code complexity in this area.
> 
> So..  is that what the _interruptible() is for?  To allow an impatient user to ^c
> a read?

Yeah, I thought so.

> If so, that sounds reasonable.  It's worth a comment explaining these decisions
> to future readers, because it is hard to work out this sort of thinking just
> from the bare C code.

Ok, no problem.


-- 
Greetings Michael.
