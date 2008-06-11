Return-Path: <linux-kernel-owner+w=401wt.eu-S1752056AbYFKFsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbYFKFsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 01:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbYFKFsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 01:48:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752518AbYFKFsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 01:48:04 -0400
Date: Tue, 10 Jun 2008 22:47:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: webmaster@dragonslave.de
Cc: Daniel Exner <dex@dragonslave.de>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: linux-next Regression: Unable to locate IOAPIC
Message-Id: <20080610224753.10ab33c5.akpm@linux-foundation.org>
In-Reply-To: <200806102229.10512.dex@dragonslave.de>
References: <200806051100.12885.dex@dragonslave.de>
	<200806061930.29046.dex@dragonslave.de>
	<20080606115024.387b5f80.akpm@linux-foundation.org>
	<200806102229.10512.dex@dragonslave.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008 22:29:10 +0200 Daniel Exner <dex@dragonslave.de> wrote:

> 
> Andrew Morton wrote:
> > On Fri, 6 Jun 2008 19:30:28 +0200 Daniel Exner <dex@dragonslave.de> wrote:
> > > Andrew Morton wrote:
> > > > (cc linux-acpi)
> > > >
> > > > On Thu, 5 Jun 2008 11:00:12 +0200 Daniel Exner <dex@dragonslave.de> 
> wrote:
> > > > > Hi!
> > > > >
> > > > > (Added myself to CC, because I'm not subscribed)
> > > > >
> > > > > with linux-next snapshot 20080604 my Laptop morphes into sitting duck
> > > > > and I think this is due to this:
> > > >
> > > > I assume 2.6.26-rc5 is OK?
> > >
> > > Indeed.. just tried it with (nearly) the same config: no unable to locate
> > > IOAPIC
> > >
> > > Will try todays next snapshot above -rc5 now.
> >
> > OK, thanks.
> >
> > It would be great if you could test 2.6.26-rc5 plus
> > http://userweb.kernel.org/~akpm/git-acpi.patch.  That'll allow us to
> > confirm that the regression is due to changes in the acpi tree.
> Sorry for the delay.. real-life you know ;)
> 
> I guess you'd expect me to confirm the behavior on rc5 with this patch aplied, 
> but .. well this Kernel works!
> 
> So I think the regression is NOT in the acpi tree. Perhaps pci subsystem?

There is behind-the-scenes finger-pointing going on ;)

I don't think we know what caused this regression, sorry.

> If I find time I'll try bisecting it..

That would be fantastic, thanks.  Please don't let us merge this
regression into 2.6.27.  We have a few weeks.

