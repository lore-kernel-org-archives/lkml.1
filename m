Return-Path: <linux-kernel-owner+w=401wt.eu-S1764864AbZDIMCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764864AbZDIMCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 08:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760567AbZDIMCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 08:02:32 -0400
Received: from aun.it.uu.se ([130.238.12.36]:37861 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760435AbZDIMCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 08:02:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18909.58298.579959.482372@pilspetsen.it.uu.se>
Date: Thu, 9 Apr 2009 14:02:02 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [BUG 2.6.29] NMI watchdog triggered in rb_insert_color called
	from enqueue_hrtimer
In-Reply-To: <18908.35477.227662.637308@pilspetsen.it.uu.se>
References: <18908.27242.966881.409415@pilspetsen.it.uu.se>
	<20090408092452.GA26121@elte.hu>
	<18908.35477.227662.637308@pilspetsen.it.uu.se>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson writes:
 > Ingo Molnar writes:
 >  > 
 >  > * Mikael Pettersson <mikpe@it.uu.se> wrote:
 >  > 
 >  > > Less than an hour after updating a dual Opteron 8384 box from 
 >  > > 2.6.29-rc6 (which it had been running for weeks) to 2.6.29 final 
 >  > > it died with the following watchdog-detected lockup:
 >  > 
 >  > Could you please check whether this is the bug fixed by:
 >  > 
 >  >   7f1e2ca: hrtimer: fix rq->lock inversion (again)
 > 
 > I am testing this now and will let you know how it goes.

The machine has now been running 2.6.29 plus that fix for more
than 24 hours with no problems. Previously it oopsed and hung
within an hour on two separate attempts to run 2.6.29 vanilla.

Thanks,

/Mikael
