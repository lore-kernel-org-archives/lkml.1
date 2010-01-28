Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240Ab0A1DYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab0A1DYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 22:24:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083Ab0A1DYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 22:24:31 -0500
Received: from outbound-mail-111.bluehost.com ([69.89.18.7]:52651 "HELO
	outbound-mail-111.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752631Ab0A1DYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 22:24:30 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=aXNAcmdh+5qOpTxMhhttoPu1afWXbrIFjWDRfXB/4P3oRrGyhmlEvcj1piomFZXdd/pbI3XHs5fxSURAhOvW7Nlw54HqzUD2G6bagtWorVzZrO9lVc5NNL18a8CCRTlc;
Date: Wed, 27 Jan 2010 19:24:09 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Jeff Garrett <jeff@jgarrett.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Myron Stowe <myron.stowe@hp.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #15124] PCI host bridge windows ignored (works with
 pci=use_crs)
Message-ID: <20100127192409.79af96db@jbarnes-piketon>
In-Reply-To: <alpine.LFD.2.00.1001271748300.3570@localhost.localdomain>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
	<201001261348.59508.rjw@sisk.pl>
	<201001261032.37053.bjorn.helgaas@hp.com>
	<201001261902.13911.rjw@sisk.pl>
	<20100126101752.78196900@jbarnes-piketon>
	<4B5F735B.2040308@kernel.org>
	<alpine.LFD.2.00.1001271748300.3570@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jan 2010 17:50:17 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Tue, 26 Jan 2010, Yinghai Lu wrote:
> > 
> > [PATCH] x86/pci: don't use ioh resource if only have one ioh
> 
> Please, no.
> 
> This patch is too ugly to live.
> 
> And it's totally unacceptable to probe every single possible PCI device 
> for something like this.
> 
> If we don't know enough about the hardware workings of those Intel bridges 
> to know when they are active and how they decode things, then please let's 
> just disable intel_bus.c entirely.
> 
> There's no excuse for hacky tests like this.

Ok, we'll just kill it entirely then.  I'll send a patch tomorrow
unless Yinghai beats me to it.

-- 
Jesse Barnes, Intel Open Source Technology Center
