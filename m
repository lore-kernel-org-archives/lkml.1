Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbYGNQ5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbYGNQ5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 12:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbYGNQ5C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 12:57:02 -0400
Received: from outbound-mail-126.bluehost.com ([67.222.38.26]:34130 "HELO
	outbound-mail-126.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752542AbYGNQ5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 12:57:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User:DomainKey-Status;
	b=qww4GzFnRBUUjEXJhOvdyOXmnqUDzE7NXXY7RUcsHCBcRSJ58fG4oPYdtoBzt6g9EHHTycTWIM0d2x6PoWw6nQIzn1RiGMpOyKSSJEDVHXUjeqgILs9dYpgwwyuPmfT+;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Olaf Dabrunz <od@suse.de>
Subject: Re: [PATCH 0/3] Boot IRQ quirks for Broadcom and AMD/ATI
Date: Mon, 14 Jul 2008 09:56:29 -0700
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jon Masters <jonathan@jonmasters.org>,
       Stefan Assmann <sassmann@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Ihno Krumreich <ihno@suse.de>, Sven Dietrich <sdietrich@suse.de>,
       Daniel Gollub <dgollub@suse.de>, Felix Foerster <ffoerster@suse.de>
References: <12155255883170-git-send-email-od@suse.de> <20080714164548.GA28499@elte.hu> <20080714164948.GA15153@suse.de>
In-Reply-To: <20080714164948.GA15153@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807140956.30085.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 14, 2008 9:49 am Olaf Dabrunz wrote:
> On 14-Jul-08, Ingo Molnar wrote:
> > * Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > > > applied to tip/x86/pci-ioapic-boot-irq-quirks, thanks Olaf.
> > > >
> > > > Jesse, what do you think about this topic? We are keeping it
> > > > separate for the time being. They are not particularly pretty, but
> > > > being able to mask/unmask irqs (without generating those legacy IRQs
> > > > and creating an IRQ storm) is essential to -rt.
> > >
> > > See my other reply; the branch looks good.  I agree that making sure
> > > -rt can work is an important feature.  My only concern is that this is
> > > touching so much hardware specific code that *something* is likely to
> > > break.  But as long as Olaf & co. can help track down any issues, I'm
> > > ok with it.
> >
> > ok. We'll cook it a bit more in tip/master and then send it over to you
> > once all the dependent changes have gone upstream in the merge window,
> > ok? I think it's v2.6.27 worthy stuff - nicely localized, sufficiently
> > finegrained and any problems with it has to be debugged the hard way by
> > exposing people to them ...
>
> Ack. :)

Sounds good, thanks.  Now to get my merge bits pulled together & tested...

Jesse
