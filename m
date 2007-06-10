Return-Path: <linux-kernel-owner+w=401wt.eu-S1759820AbXFJQ2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759820AbXFJQ2h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 12:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbXFJQ23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 12:28:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35343 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618AbXFJQ23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 12:28:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch-mm 06/23] clockevents: Fix resume logic
Date: Sun, 10 Jun 2007 18:34:19 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Chris Wright <chrisw@sous-sol.org>
References: <20070610092437.118387863@inhelltoy.tec.linutronix.de> <200706101258.48721.rjw@sisk.pl> <1181481454.384.13.camel@chaos>
In-Reply-To: <1181481454.384.13.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706101834.19977.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 10 June 2007 15:17, Thomas Gleixner wrote:
> On Sun, 2007-06-10 at 12:58 +0200, Rafael J. Wysocki wrote:
> >
> > This is the resume part, or at least it seems so, but the above one is a
> > suspend callback.  If I understand it correctly, this one replaces
> > hpet_resume(), but is it sufficient for the suspend part too?
> 
> Oops. Sorry, misunderstood you. Yeah, it's intentional. It gets reset on
> power off and we have not seen any problems with this yet.

OK, I wouldn't do it in this patch, though.

IMO it's a bit more than the changelog says and we'll lose the track record of
this change if it goes like this.  Would that be possible to separate it?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
