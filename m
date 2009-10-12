Return-Path: <linux-kernel-owner+w=401wt.eu-S1757998AbZJLTbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998AbZJLTbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 15:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757917AbZJLTbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 15:31:43 -0400
Received: from 139-142-54-143.atc.vaillant.ca ([139.142.54.143]:35542 "EHLO
	quartz.edm.orcorp.ca" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757657AbZJLTbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 15:31:43 -0400
Date: Mon, 12 Oct 2009 13:30:48 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Machek <pavel@ucw.cz>, Roland Dreier <rdreier@cisco.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-rdma@vger.kernel.org,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Anton Blanchard <anton@samba.org>, general@lists.openfabrics.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       Jeff Squyres <jsquyres@cisco.com>
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
Message-ID: <20091012193048.GA20313@obsidianresearch.com>
References: <1253187028.8439.2.camel@twins> <adafxalejiq.fsf@cisco.com> <adaab0tej5c.fsf@cisco.com> <1253198976.14935.27.camel@laptop> <adazl8td35u.fsf@cisco.com> <adatyz1d17q.fsf@cisco.com> <20090929171332.GD14405@elf.ucw.cz> <20090930094456.GD24621@elte.hu> <20090930160232.GZ22310@obsidianresearch.com> <20091012181944.GF17138@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012181944.GF17138@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 08:19:44PM +0200, Ingo Molnar wrote:

> > After that point the scheme is perfectly lossless.
> 
> Well if it can OOM it's not lossless, obviously. You just define "event 
> loss" to be equivalent to "Destruction of the universe." ;-)

It can't OOM once the ummunotify registration is done - when an event
occurs it doesn't allocate any memory and it doesn't loose events.

It has the same problem as perf - you either bound the number/size of
filters, or let user space allocate filters until the box OOMs. perf
has the additonal problem that even with filters you can still loose
events if the event ring overflows.

Jason
