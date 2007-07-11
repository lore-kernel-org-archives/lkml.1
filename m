Return-Path: <linux-kernel-owner+w=401wt.eu-S1765689AbXGKRuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765689AbXGKRuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 13:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757376AbXGKRua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 13:50:30 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:12110 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040AbXGKRu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 13:50:29 -0400
Date: Wed, 11 Jul 2007 20:50:26 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andi Kleen <ak@suse.de>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@osdl.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jon Mason <jdmason@gmail.com>
Subject: Re: [PATCH 1/1] x86-64: introduce struct pci_sysdata to facilitate sharing of ->sysdata
Message-ID: <20070711175026.GC4189@rhun.haifa.ibm.com>
References: <20070711134514.GA4789@rhun.haifa.ibm.com> <46950857.4010302@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46950857.4010302@sun.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 09:41:59AM -0700, Yinghai Lu wrote:
> Muli Ben-Yehuda wrote:
> >Andi, please consider applying for 2.6.23. Applies on top of the
> >Calgary update I just sent out ("Calgary: more updates for 2.6.23").
> >
> >This patch introduces struct pci_sysdata to x86 and x86-64, and
> >converts the existing two users (NUMA, Calgary) to use it.
> >
> >This lays the groundwork for having other users of sysdata, such as
> >the PCI domains work.
> >
> >The Calgary bits are tested, the NUMA bits just look ok.
> >
> >Signed-off-by: Jeff Garzik <jeff@garzik.org>
> >Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
> 
> how about acpi=off in x86_64 system?

Are you asking if it works? my main victim machines don't boot at all
with acpi=off regardless of this patch so I can't test it there. I'll
try to find a sacrifical Opteron machine to try it on.

> You maybe update this with
> http://lkml.org/lkml/2007/6/29/246
> Andrew already sent that to Andi for 2.6.23

It's in Andi's "need more review" list, so I guess it depends on
Andi's preference which (if any) of these patches will go in
first. Andi?

Cheers,
Muli
