Return-Path: <linux-kernel-owner+w=401wt.eu-S1756765AbYFJUaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765AbYFJUaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 16:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbYFJU3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 16:29:52 -0400
Received: from server009.webpack.hosteurope.de ([80.237.130.17]:49690 "EHLO
	server009.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752078AbYFJU3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 16:29:51 -0400
From: Daniel Exner <dex@dragonslave.de>
Reply-To: webmaster@dragonslave.de
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next Regression: Unable to locate IOAPIC
Date: Tue, 10 Jun 2008 22:29:10 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-acpi@vger.kernel.org
References: <200806051100.12885.dex@dragonslave.de> <200806061930.29046.dex@dragonslave.de> <20080606115024.387b5f80.akpm@linux-foundation.org>
In-Reply-To: <20080606115024.387b5f80.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806102229.10512.dex@dragonslave.de>
X-bounce-key: webpack.hosteurope.de;dex@dragonslave.de;1213129790;68fa08e7;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew Morton wrote:
> On Fri, 6 Jun 2008 19:30:28 +0200 Daniel Exner <dex@dragonslave.de> wrote:
> > Andrew Morton wrote:
> > > (cc linux-acpi)
> > >
> > > On Thu, 5 Jun 2008 11:00:12 +0200 Daniel Exner <dex@dragonslave.de> 
wrote:
> > > > Hi!
> > > >
> > > > (Added myself to CC, because I'm not subscribed)
> > > >
> > > > with linux-next snapshot 20080604 my Laptop morphes into sitting duck
> > > > and I think this is due to this:
> > >
> > > I assume 2.6.26-rc5 is OK?
> >
> > Indeed.. just tried it with (nearly) the same config: no unable to locate
> > IOAPIC
> >
> > Will try todays next snapshot above -rc5 now.
>
> OK, thanks.
>
> It would be great if you could test 2.6.26-rc5 plus
> http://userweb.kernel.org/~akpm/git-acpi.patch.  That'll allow us to
> confirm that the regression is due to changes in the acpi tree.
Sorry for the delay.. real-life you know ;)

I guess you'd expect me to confirm the behavior on rc5 with this patch aplied, 
but .. well this Kernel works!

So I think the regression is NOT in the acpi tree. Perhaps pci subsystem?
If I find time I'll try bisecting it..

Greetings
Daniel Exner
