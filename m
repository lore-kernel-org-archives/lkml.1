Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbZKIPpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbZKIPpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 10:45:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbZKIPpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 10:45:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51355 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbZKIPpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 10:45:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: Help needed: Resume problems in 2.6.32-rc, perhaps related to preempt_count leakage in keventd
Date: Mon, 9 Nov 2009 16:47:03 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.31.5-tst; KDE/4.3.1; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <200911091250.31626.rjw@sisk.pl> <200911091526.02147.rjw@sisk.pl> <1257777896.6365.21.camel@marge.simson.net>
In-Reply-To: <1257777896.6365.21.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200911091647.03502.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 November 2009, Mike Galbraith wrote:
> On Mon, 2009-11-09 at 15:26 +0100, Rafael J. Wysocki wrote:
> 
> > Well, I can add the printk(), but I can't guarantee that I will get the call
> > trace once again.  So far I've seen it only once after 20-25 consecutive
> > suspend-resume cycles, so ...  you get the idea.
> > 
> > However, running on a wrong CPU would very nicely explain all of the observed
> > symptoms, so I guess we can try a House M.D.-alike approach and assume that the
> > answer is "yes, we're running on the wrong CPU".  What would we do next if that
> > was the case?
> 
> If you're interested in trying a patch, I have a couple that fix things
> up here.  My "get a bigger hammer" patch would be best if it's what I
> think it is.  If it only fails once in a blue moon though, maybe not
> worth even trying.  If I could suspend/resume, I'd try it myself, but I
> have (steenking) nvidia card.  No eyecandy or resume for me, though I
> can suspend... once.

OK, please send me (a) poiter(s) to the patches.

I'll first try the patch you've just sent and report back. 

Thanks,
Rafael
