Return-Path: <linux-kernel-owner+w=401wt.eu-S1753610Ab0A1EDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab0A1EDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 23:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089Ab0A1EDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 23:03:16 -0500
Received: from jgarrett.org ([64.5.53.252]:33570 "EHLO jgarrett.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014Ab0A1EDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 23:03:15 -0500
Date: Wed, 27 Jan 2010 22:01:48 -0600
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Yinghai Lu <yinghai@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Myron Stowe <myron.stowe@hp.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #15124] PCI host bridge windows ignored (works with
 pci=use_crs)
Message-ID: <20100128040148.GA8964@jgarrett.org>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
 <201001261348.59508.rjw@sisk.pl>
 <201001261032.37053.bjorn.helgaas@hp.com>
 <201001261902.13911.rjw@sisk.pl>
 <20100126101752.78196900@jbarnes-piketon>
 <4B5F735B.2040308@kernel.org>
 <20100127173550.14737320@jbarnes-piketon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100127173550.14737320@jbarnes-piketon>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: jeff@jgarrett.org (Jeff Garrett)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 05:35:50PM -0800, Jesse Barnes wrote:
> On Tue, 26 Jan 2010 14:57:31 -0800
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
> > On 01/26/2010 10:17 AM, Jesse Barnes wrote:
> > 
> > > 
> > > For 2.6.33 I'd like a minimal fix though, can you disable it for all
> > > but the multi-IOH case perhaps?
> > > 
> > please check,
> > 
> > [PATCH] x86/pci: don't use ioh resource if only have one ioh
> > 
> > some system could use reosurce out of IOH resources when only one ioh is there.
> > 
> > could be BIOS have wrong IOH resources and not enable them.
> > 
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> I applied this one to my for-linus branch.  Jeff can you confirm it
> works for you?  I'd like to push it to Linus tomorrow.
> 
> Thanks,

FWIW, works...
