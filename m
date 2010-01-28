Return-Path: <linux-kernel-owner+w=401wt.eu-S932291Ab0A1Tji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab0A1Tji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 14:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275Ab0A1Tjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 14:39:37 -0500
Received: from alt.dspnet.fr.eu.org ([213.186.44.138]:1209 "EHLO
	dspnet.fr.eu.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751236Ab0A1Tjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 14:39:36 -0500
X-Greylist: delayed 543 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jan 2010 14:39:36 EST
Date: Thu, 28 Jan 2010 20:30:27 +0100
From: Olivier Galibert <galibert@pobox.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jeff Garrett <jeff@jgarrett.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Myron Stowe <myron.stowe@hp.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -v2] x86/pci: print ioh resources only
Message-ID: <20100128193027.GA13741@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Yinghai Lu <yinghai@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Jeff Garrett <jeff@jgarrett.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Bjorn Helgaas <bjorn.helgaas@hp.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Linux PCI <linux-pci@vger.kernel.org>,
	Myron Stowe <myron.stowe@hp.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>
References: <201001261902.13911.rjw@sisk.pl> <20100126101752.78196900@jbarnes-piketon> <4B5F735B.2040308@kernel.org> <alpine.LFD.2.00.1001271748300.3570@localhost.localdomain> <20100127192409.79af96db@jbarnes-piketon> <20100128040226.GB8964@jgarrett.org> <20100128082432.05a97ebc@jbarnes-piketon> <4B61D7C4.1050405@kernel.org> <alpine.LFD.2.00.1001281052510.22433@localhost.localdomain> <4B61E116.6050208@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B61E116.6050208@kernel.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 11:10:14AM -0800, Yinghai Lu wrote:
> 
> don't use them for peer pci root bus resource yet.
> so could cross check _CRS results
> 
> -v2: dont put info struct in stack according to Linus.
>      because that is kbytes big

No kfree?

  OG.
