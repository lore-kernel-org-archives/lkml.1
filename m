Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbYITX1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbYITX1T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 19:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbYITX1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 19:27:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53810 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbYITX1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 19:27:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Regression] Commit 2344abbcbdb82140050e8be29d3d55e4f6fe860b breaks resume on nx6325
Date: Sun, 21 Sep 2008 01:32:45 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Kernel Testers <kernel-testers@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>
References: <200809210124.30547.rjw@sisk.pl>
In-Reply-To: <200809210124.30547.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809210132.46504.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 21 of September 2008, Rafael J. Wysocki wrote:
> Hi,
> 
> Unfortunately resume from suspend to RAM is completely broken on my hp nx6325
> because of
> 
> commit 2344abbcbdb82140050e8be29d3d55e4f6fe860b
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Tue Sep 16 11:32:50 2008 -0700
> 
>     clockevents: make device shutdown robust
> 
>     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Reverting of this commit makes things work again.

One more thing, "broken" means that the box doesn't resume (the suspend part
seems to work correctly) and instead it seems to enter a neverending loop
that cannot be broken by any means except for the power button, so I think it
occurs with interrupts disabled.

Thanks,
Rafael
