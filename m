Return-Path: <linux-kernel-owner+w=401wt.eu-S1762865AbXF0U0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762865AbXF0U0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 16:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753743AbXF0U0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 16:26:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:36574 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbXF0U0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 16:26:32 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86_64: change _map_single to static in pci_gart.c etc
Date: Wed, 27 Jun 2007 22:26:29 +0200
User-Agent: KMail/1.9.6
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Muli Ben-Yehuda" <muli@il.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <200706271041.21937.yinghai.lu@sun.com> <200706272222.25153.ak@suse.de> <86802c440706271325w3a8b6d9aybb8a346b9b2eb345@mail.gmail.com>
In-Reply-To: <86802c440706271325w3a8b6d9aybb8a346b9b2eb345@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706272226.29231.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 June 2007 22:25:11 Yinghai Lu wrote:
> On 6/27/07, Andi Kleen <ak@suse.de> wrote:
> > On Wednesday 27 June 2007 19:41:21 Yinghai Lu wrote:
> > > [PATCH] x86_64: change _map_single to static in pci_gart.c etc
> > >
> > > there function is called via dma_ops->.., so change it to static
> >
> > Actually all these functions shouldn't be inline in the first place.
> 
> do you mean pci_map_single==>dma_map_single==>gart_map_single?

dma_map_single. pci_map_single is ok because it doesn't really 
change anything.

-Andi
