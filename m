Return-Path: <linux-kernel-owner+w=401wt.eu-S1751299AbXBUP2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299AbXBUP2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 10:28:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbXBUP2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 10:28:39 -0500
Received: from www.osadl.org ([213.239.205.134]:36094 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751299AbXBUP2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 10:28:37 -0500
Subject: Re: 2.6.20-git15 BUG: soft lockup detected on CPU#0! - timers?
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <6bffcb0e0702201437o66db38d5j3066eb3c9951a270@mail.gmail.com>
References: <6bffcb0e0702201054rb839bb2m11ef8d33bacffdb8@mail.gmail.com>
	 <1172008584.25076.0.camel@localhost.localdomain>
	 <6bffcb0e0702201437o66db38d5j3066eb3c9951a270@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 21 Feb 2007 16:33:43 +0100
Message-Id: <1172072023.25076.64.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-20 at 23:37 +0100, Michal Piotrowski wrote:
> On 20/02/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Tue, 2007-02-20 at 19:54 +0100, Michal Piotrowski wrote:
> > >
> > > Might it be 6ba9b346e1e0eca65ec589d32de3a9fe32dc5de6 commit?
> >
> > I doubt that it is, but can you revert it ?
> 
> I'm using the latest kernel without this patch since 3 hours.
> 
> So far so good.

But you still have those softirq pending messages, right ? I think those
are pointing to the root cause of this. Still no idea how to get hold of
them. All my systems refuse to produce that. Hrmpf.

	tglx


