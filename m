Return-Path: <linux-kernel-owner+w=401wt.eu-S1762733AbYFFSuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762733AbYFFSuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 14:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755689AbYFFSuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 14:50:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57806 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755063AbYFFSub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 14:50:31 -0400
Date: Fri, 6 Jun 2008 11:50:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: webmaster@dragonslave.de
Cc: Daniel Exner <dex@dragonslave.de>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: linux-next Regression: Unable to locate IOAPIC
Message-Id: <20080606115024.387b5f80.akpm@linux-foundation.org>
In-Reply-To: <200806061930.29046.dex@dragonslave.de>
References: <200806051100.12885.dex@dragonslave.de>
	<20080606031718.36cbbdc9.akpm@linux-foundation.org>
	<200806061930.29046.dex@dragonslave.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008 19:30:28 +0200 Daniel Exner <dex@dragonslave.de> wrote:

> Andrew Morton wrote:
> > (cc linux-acpi)
> >
> > On Thu, 5 Jun 2008 11:00:12 +0200 Daniel Exner <dex@dragonslave.de> wrote:
> > > Hi!
> > >
> > > (Added myself to CC, because I'm not subscribed)
> > >
> > > with linux-next snapshot 20080604 my Laptop morphes into sitting duck and
> > > I think this is due to this:
> >
> > I assume 2.6.26-rc5 is OK?
> Indeed.. just tried it with (nearly) the same config: no unable to locate 
> IOAPIC
> 
> Will try todays next snapshot above -rc5 now.

OK, thanks.

It would be great if you could test 2.6.26-rc5 plus
http://userweb.kernel.org/~akpm/git-acpi.patch.  That'll allow us to
confirm that the regression is due to changes in the acpi tree.

> BTW: Any chance to get this damn thing to not route everything by IRQ 11 !?

ooh, wrong guy to ask, sorry.
