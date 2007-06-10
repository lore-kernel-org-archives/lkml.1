Return-Path: <linux-kernel-owner+w=401wt.eu-S1755536AbXFJSqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536AbXFJSqI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 14:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756819AbXFJSpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 14:45:55 -0400
Received: from www.osadl.org ([213.239.205.134]:33737 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755462AbXFJSpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 14:45:51 -0400
Subject: Re: [patch-mm 06/23] clockevents: Fix resume logic
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <200706101834.19977.rjw@sisk.pl>
References: <20070610092437.118387863@inhelltoy.tec.linutronix.de>
	 <200706101258.48721.rjw@sisk.pl> <1181481454.384.13.camel@chaos>
	 <200706101834.19977.rjw@sisk.pl>
Content-Type: text/plain
Date: Sun, 10 Jun 2007 20:45:49 +0200
Message-Id: <1181501149.8176.0.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-06-10 at 18:34 +0200, Rafael J. Wysocki wrote:
> On Sunday, 10 June 2007 15:17, Thomas Gleixner wrote:
> > On Sun, 2007-06-10 at 12:58 +0200, Rafael J. Wysocki wrote:
> > >
> > > This is the resume part, or at least it seems so, but the above one is a
> > > suspend callback.  If I understand it correctly, this one replaces
> > > hpet_resume(), but is it sufficient for the suspend part too?
> > 
> > Oops. Sorry, misunderstood you. Yeah, it's intentional. It gets reset on
> > power off and we have not seen any problems with this yet.
> 
> OK, I wouldn't do it in this patch, though.
> 
> IMO it's a bit more than the changelog says and we'll lose the track record of
> this change if it goes like this.  Would that be possible to separate it?

Sure. Will do.

	tglx


