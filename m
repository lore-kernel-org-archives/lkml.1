Return-Path: <linux-kernel-owner+w=401wt.eu-S939403AbXGSQas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939403AbXGSQas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 12:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765408AbXGSQak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 12:30:40 -0400
Received: from gw.goop.org ([64.81.55.164]:37004 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764176AbXGSQaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 12:30:39 -0400
Message-ID: <469F9178.7060801@goop.org>
Date: Thu, 19 Jul 2007 09:29:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Jan Glauber <jang@linux.vnet.ibm.com>, Andi Kleen <ak@suse.de>,
       Zachary Amsden <zach@vmware.com>
Subject: Re: [patch] sched: implement cpu_clock(cpu) high-speed time source,
 take #2
References: <469F793E.6030006@goop.org> <20070719145058.GA11971@elte.hu> <469F7D7A.204@goop.org> <20070719150955.GA19373@elte.hu> <469F8179.2060802@goop.org> <20070719154254.GA24225@elte.hu> <20070719154449.GA28998@elte.hu> <469F8D28.1010304@goop.org> <20070719161643.GA5153@elte.hu> <469F8EBE.5020703@goop.org> <20070719162114.GA6154@elte.hu>
In-Reply-To: <20070719162114.GA6154@elte.hu>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> that's still an important question, but these changes are still needed 
> nevertheless, to unbreak softlockup.c 

Well, I'm happy with using jiffies as the backport fix for softlockup
(if sched_clock is indeed a problem there), but mainly because it won't
affect Xen.  I don't know what effect it will have on vmi though.

cpu_clock seems like a good approach for .23 onwards.  I guess I should
test it at some point...

    J


