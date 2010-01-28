Return-Path: <linux-kernel-owner+w=401wt.eu-S1756165Ab0A1QY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab0A1QY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 11:24:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755936Ab0A1QY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 11:24:57 -0500
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:52197 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755122Ab0A1QY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 11:24:56 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=SERE+TXuNSJiTy4dH6Q1pMjWweOWNhddswVxy1d4o9SZaX/MwfSphN7HdKYtG2KF8nJZr0nKtXRj8IiHg4OARfj99Pd665SpQrbIWwLIKycIJQMrEMsVQbLPHGL/bFqC;
Date: Thu, 28 Jan 2010 08:24:32 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: jeff@jgarrett.org (Jeff Garrett)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Myron Stowe <myron.stowe@hp.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #15124] PCI host bridge windows ignored (works with
 pci=use_crs)
Message-ID: <20100128082432.05a97ebc@jbarnes-piketon>
In-Reply-To: <20100128040226.GB8964@jgarrett.org>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
	<201001261348.59508.rjw@sisk.pl>
	<201001261032.37053.bjorn.helgaas@hp.com>
	<201001261902.13911.rjw@sisk.pl>
	<20100126101752.78196900@jbarnes-piketon>
	<4B5F735B.2040308@kernel.org>
	<alpine.LFD.2.00.1001271748300.3570@localhost.localdomain>
	<20100127192409.79af96db@jbarnes-piketon>
	<20100128040226.GB8964@jgarrett.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jan 2010 22:02:26 -0600
jeff@jgarrett.org (Jeff Garrett) wrote:

> On Wed, Jan 27, 2010 at 07:24:09PM -0800, Jesse Barnes wrote:
> > On Wed, 27 Jan 2010 17:50:17 -0800 (PST)
> > Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > > On Tue, 26 Jan 2010, Yinghai Lu wrote:
> > > > 
> > > > [PATCH] x86/pci: don't use ioh resource if only have one ioh
> > > 
> > > Please, no.
> > > 
> > > This patch is too ugly to live.
> > > 
> > > And it's totally unacceptable to probe every single possible PCI device 
> > > for something like this.
> > > 
> > > If we don't know enough about the hardware workings of those Intel bridges 
> > > to know when they are active and how they decode things, then please let's 
> > > just disable intel_bus.c entirely.
> > > 
> > > There's no excuse for hacky tests like this.
> > 
> > Ok, we'll just kill it entirely then.  I'll send a patch tomorrow
> > unless Yinghai beats me to it.
> 
> What about something like this (works for me, without pci=use_crs)?
> 
> ---
>     Remove intel_bus.c Intel-specific PCI/IOH logic
>     
>     Signed-off-by: Jeff Garrett <jeff@jgarrett.org>

Yeah, looks good.  I'll push to Linus today.

Thanks,
Jesse

-- 
Jesse Barnes, Intel Open Source Technology Center
