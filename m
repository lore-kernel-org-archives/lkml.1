Return-Path: <linux-kernel-owner+w=401wt.eu-S1753642AbZKIOo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbZKIOo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 09:44:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbZKIOoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 09:44:55 -0500
Received: from mail.gmx.net ([213.165.64.20]:37470 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752318AbZKIOoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 09:44:54 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1++tABYBhS+XDCncq4gKk8fR8jcIGRfSK7rwOzwG5
	bHOUm17tOqR7cd
Subject: Re: Help needed: Resume problems in 2.6.32-rc, perhaps related to
 preempt_count leakage in keventd
From: Mike Galbraith <efault@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <200911091526.02147.rjw@sisk.pl>
References: <200911091250.31626.rjw@sisk.pl>
	 <20091109124937.GA21114@elte.hu>
	 <alpine.LFD.2.00.0911091452300.2725@localhost.localdomain>
	 <200911091526.02147.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 09 Nov 2009 15:44:56 +0100
Message-Id: <1257777896.6365.21.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-09 at 15:26 +0100, Rafael J. Wysocki wrote:

> Well, I can add the printk(), but I can't guarantee that I will get the call
> trace once again.  So far I've seen it only once after 20-25 consecutive
> suspend-resume cycles, so ...  you get the idea.
> 
> However, running on a wrong CPU would very nicely explain all of the observed
> symptoms, so I guess we can try a House M.D.-alike approach and assume that the
> answer is "yes, we're running on the wrong CPU".  What would we do next if that
> was the case?

If you're interested in trying a patch, I have a couple that fix things
up here.  My "get a bigger hammer" patch would be best if it's what I
think it is.  If it only fails once in a blue moon though, maybe not
worth even trying.  If I could suspend/resume, I'd try it myself, but I
have (steenking) nvidia card.  No eyecandy or resume for me, though I
can suspend... once.

	-Mike

