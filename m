Return-Path: <linux-kernel-owner+w=401wt.eu-S1765591AbXFETul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765591AbXFETul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 15:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763433AbXFETue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 15:50:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37201 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763001AbXFETud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 15:50:33 -0400
Date: Tue, 5 Jun 2007 12:50:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Linux 2.6.22-rc4
In-Reply-To: <20070605193718.GB24877@elte.hu>
Message-ID: <alpine.LFD.0.98.0706051245190.4921@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0706042040350.23741@woody.linux-foundation.org>
 <4665B169.2030803@googlemail.com> <alpine.LFD.0.98.0706051219560.4921@woody.linux-foundation.org>
 <20070605193718.GB24877@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 5 Jun 2007, Ingo Molnar wrote:
> 
> isnt the refrigerator() suspend related? Perhaps suspend disables irqs 
> somewhere that we forgot to track?

There _is_ something strange there. For that whole sequence to trigger, 
the current task has to have the TIF_FREEZE bit set, but I don't see why 
it would be during shutdown.

		Linus
