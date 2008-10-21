Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbYJUTfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbYJUTfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 15:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbYJUTe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 15:34:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54902 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbYJUTe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 15:34:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [announce] new tree: "fix all build warnings, on all configs"
Date: Tue, 21 Oct 2008 21:39:38 +0200
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       David Howells <dhowells@redhat.com>
References: <20081017171139.GA1792@elte.hu> <20081021111716.GA4476@elte.hu> <20081021120720.GG12825@one.firstfloor.org>
In-Reply-To: <20081021120720.GG12825@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810212139.39470.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 21 of October 2008, Andi Kleen wrote:
> On Tue, Oct 21, 2008 at 01:17:16PM +0200, Ingo Molnar wrote:
> > 
> > * Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > >   *	acpi_pm_disable_gpes - Disable the GPEs.
> > > >   */
> > > > -static int acpi_pm_disable_gpes(void)
> > > > +static inline int acpi_pm_disable_gpes(void)
> > > 
> > > Just to satisfy my curiosity, what compiler warning does marking 
> > > functions inline fix?
> > 
> > the commit log below explains the situation. The warning exposed a maze 
> > of #ifdefs in drivers/acpi/sleep/main.c. It's not the warning we need to 
> > "fix" but that maze, obviously.
> 
> Thanks. That makes sense, 
> 
> I also agree with you that the better alternative would be 
> to just always force SUSPEND together with ACPI.
> 
> I suspect the code delta wouldn't be very large compared to the rest
> of the ACPI code.

Is that _really_ necessary?

I mean, do the warnings appear in any case that's not theoretically impossible?

Rafael
