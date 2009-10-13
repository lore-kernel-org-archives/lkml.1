Return-Path: <linux-kernel-owner+w=401wt.eu-S1760218AbZJMPPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760218AbZJMPPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 11:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760201AbZJMPPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 11:15:46 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:30496 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760174AbZJMPPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 11:15:45 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] pci: increase alignment to make more space for hidden code
Date: Tue, 13 Oct 2009 09:15:03 -0600
User-Agent: KMail/1.9.10
Cc: Yinghai Lu <yinghai@kernel.org>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Ricardo Jorge da Fonseca Marques Ferreira 
	<storm@sys49152.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Yannick Roehlly <yannick.roehlly@free.fr>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, x86@kernel.org,
       andreaorru91@gmail.com, jjorge@free.fr
References: <200908072333.24631.storm@sys49152.net> <1255414115.14484.47.camel@dc7800.home> <20091013064901.GD9470@elte.hu>
In-Reply-To: <20091013064901.GD9470@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910130915.04697.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 October 2009 12:49:01 am Ingo Molnar wrote:
> * Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> > In the patch below, I added some extra PCI dumps of the bridge and the 
> > NIC around the ACPI EC init.  The patch also removes Yinghai's 
> > workaround so we should see the original failure, just with a little 
> > more debug.
> 
> Btw., i'd _strongly_ suggest to finally add some sort of pci=verbose 
> easy-to-use debug toggle for users to enable.
> 
> Everything that matters to resource allocation. We should print the BIOS 
> state (Yinghai did a patch for this some time ago and that is upstream 
> already), we should print quirk execution, we should print ACPI AML 
> execution - everything that might matter to PCI allocations.
> 
> An easy-to-use 'give me all the debug info' feature is really important. 
> We have apic=verbose for similar reasons.

Agreed.  That's why I sent such a huge testing patch -- I think we do
a poor job of making this stuff debuggable, so I want to use this problem
as a test case of "what useful stuff can we print to make this easier in
the future."

Bjorn
