Return-Path: <linux-kernel-owner+w=401wt.eu-S934310AbXGKWVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934310AbXGKWVp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763090AbXGKWVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:21:32 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:51270 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760166AbXGKWVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:21:31 -0400
Date: Wed, 11 Jul 2007 15:20:40 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Valdis.Kletnieks@vt.edu
Cc: Chris Wright <chrisw@sous-sol.org>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
Message-ID: <20070711222040.GA4306@sequoia.sous-sol.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu> <20070711211638.GE18767@one.firstfloor.org> <28188.1184190381@turing-police.cc.vt.edu> <20070711215412.GZ4306@sequoia.sous-sol.org> <29701.1184191888@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29701.1184191888@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Valdis.Kletnieks@vt.edu (Valdis.Kletnieks@vt.edu) wrote:
> Andrew - how do you feel about keeping this in the -mm tree until Linus,
> Andi, Ingo, and Thomas get on the same page (which may be around the 2.6.24
> merge window, by my guesstimate)?

Well, that's supposed to be Andi's tree and aggregated by Andrew into -mm.
But keeping it in -mm isn't the hard part.  It's getting enough testing
to convince Linus it's safe, since there's no simple way to enable
clockevents in a slow manner.  IOW, keeping it in -mm just postpones the
issue.
