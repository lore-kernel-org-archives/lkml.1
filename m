Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482Ab0A0Uvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab0A0Uvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 15:51:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806Ab0A0Uvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 15:51:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752164Ab0A0Uvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 15:51:44 -0500
Date: Wed, 27 Jan 2010 12:50:12 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Yinghai Lu <yinghai@kernel.org>,
       Jeff Garrett <jeff@jgarrett.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Myron Stowe <myron.stowe@hp.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #15124] PCI host bridge windows ignored (works with
 pci=use_crs)
In-Reply-To: <201001271345.54454.bjorn.helgaas@hp.com>
Message-ID: <alpine.LFD.2.00.1001271247450.3570@localhost.localdomain>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera> <201001270945.17113.bjorn.helgaas@hp.com> <20100127085337.6ff06f6e@jbarnes-piketon> <201001271345.54454.bjorn.helgaas@hp.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 27 Jan 2010, Bjorn Helgaas wrote:
> 
> Without intel_bus.c, we essentially assume config 1 all the time.
> If we keep intel_bus.c and this patch for .33, things should work
> for configs 1 and 4.  Adding support for config 4 is good.

Quite frankly, is there any major downside to just disabling/removing 
intel_bus.c for 2.6.33? If we're not planning on having it in the long run 
anyway - or even if we are, but we can't be really happy about the state 
of it as it would be in 2.6.33, not using it at all seems to be the 
smaller headache.

The machines that it helps are also the machines where you can fix things 
up with 'use_csr', no? And they are pretty rare, and they didn't use to 
work without that use_csr in 2.6.32 either, so it's not even a regression.

Am I missing something?

		Linus
