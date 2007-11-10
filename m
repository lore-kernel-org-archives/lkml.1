Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbXKJV0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbXKJV0R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 16:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbXKJV0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 16:26:05 -0500
Received: from thunk.org ([69.25.196.29]:38380 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524AbXKJV0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 16:26:04 -0500
Date: Sat, 10 Nov 2007 16:24:00 -0500
From: Theodore Tso <tytso@mit.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paul Mundt <lethal@linux-sh.org>, Jeff Garzik <jeff@garzik.org>,
       Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/11 v3] enable "make ARCH=x86"
Message-ID: <20071110212400.GA7958@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>, Paul Mundt <lethal@linux-sh.org>,
	Jeff Garzik <jeff@garzik.org>, Sam Ravnborg <sam@ravnborg.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20071109230812.GA5176@uranus.ravnborg.org> <4735242B.1010801@garzik.org> <20071110075444.GA5707@uranus.ravnborg.org> <20071110082152.GA18632@linux-sh.org> <47356AD5.4070102@garzik.org> <20071110084447.GA18780@linux-sh.org> <473615F5.5090908@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473615F5.5090908@zytor.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2007 at 12:35:01PM -0800, H. Peter Anvin wrote:
> In fact, we should be able to get rid of ARCH entirely;  CONFIG_ options 
> have the huge advantage that they're saved in a file, and you don't have to 
> type them on every make run. The only option that I can't see us getting 
> rid of easily is HOSTCC, since it is used before config is run, but 
> probably something clever can be done there, too.

Yes, please!  One of the more annoying things is forgetting the
ARCH=um when rebuilding UML.  It would be awfully nice if ARCH was set
via a CONFIG_ option and was persistent.

					- Ted
