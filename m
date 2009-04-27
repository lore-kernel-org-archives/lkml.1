Return-Path: <linux-kernel-owner+w=401wt.eu-S1758741AbZD0TsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741AbZD0TsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 15:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbZD0TsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 15:48:11 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:52987 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbZD0TsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 15:48:11 -0400
Message-ID: <49F60BF8.8040404@ovro.caltech.edu>
Date: Mon, 27 Apr 2009 12:48:08 -0700
From: David Hawkins <dwh@ovro.caltech.edu>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Timur Tabi <timur@freescale.com>
CC: linuxppc-dev@ozlabs.org, Dan Williams <dan.j.williams@intel.com>,
       Liu Dave-R63238 <DaveLiu@freescale.com>, linux-kernel@vger.kernel.org,
       Ira Snyder <iws@ovro.caltech.edu>
Subject: Re: [PATCH] fsldma: use PCI Read Multiple command
References: <20090424183517.GB23140@ovro.caltech.edu>	<D7CCA83BB0796C49BC0BB53B6AB1208928CA1D@zch01exm21.fsl.freescale.net>	<ed82fe3e0904270731g2d2519a7mc12e4152c716c0a9@mail.gmail.com>	<49F608B7.9080409@ovro.caltech.edu> <49F60A3A.4060402@freescale.com>
In-Reply-To: <49F60A3A.4060402@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Mon, 27 Apr 2009 12:48:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>> Would you like some sort of summary of this info for a commit
>> message?
> 
> That's probably overkill.  I just want a sentence or two that tells
> someone looking at the code casually that the behavior of reading PCI
> memory might be different than what they expect.

Ok, will-do.

>> Would you like us to check any other transaction/register combos?
> 
> Yes, could you try this on non-PCI memory?

We've been using it to DMA between the x86 host main memory and
the MPC8349EA boards (PCI targets). The reason we changed to
Read Multiple was that it had a dramatic improvement in
efficiency through bridges. However, the x86 host memory
is prefetchable, so is consistent with the use of Read Multiple.

Can you give me an example of non-PCI memory that would be
non-prefetchable that you'd like us to try? We can see if our
host CPUs have an area like that ... we just need to know
what device to look for first :)

Cheers,
Dave



