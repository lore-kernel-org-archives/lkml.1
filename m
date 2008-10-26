Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbYJZSKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbYJZSKY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 14:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbYJZSKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 14:10:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54779 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641AbYJZSKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 14:10:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "Mikko C." <mikko.cal@gmail.com>
Subject: Re: Bug in workqueues [was: Usb devices randomly aren't detected with 2.6.28-rc1-git1]
Date: Sun, 26 Oct 2008 19:14:39 +0100
User-Agent: KMail/1.9.9
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
References: <Pine.LNX.4.44L0.0810261327170.25044-100000@netrider.rowland.org> <200810261855.47580.rjw@sisk.pl> <alpine.LFD.2.00.0810261057290.5200@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810261057290.5200@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810261914.40825.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 26 of October 2008, Linus Torvalds wrote:
> 
> On Sun, 26 Oct 2008, Rafael J. Wysocki wrote:
> > > 
> > > So apparently flush_workqueue() isn't working.
> > 
> > Let's make that more visible (adding CCs). :-)
> 
> Isn't this the same thing that was fixed by commit 
> 4403b406d4369a275d483ece6ddee0088cc0d592: aka 'Revert "Call 
> init_workqueues before pre smp initcalls."'

OK, I've closed bug #11853 with this assumption.  Mikko, if it happens again
with 2.6.28-rc1-git3 or later, please reopen.

Thanks,
Rafael
