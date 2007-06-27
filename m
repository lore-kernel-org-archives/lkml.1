Return-Path: <linux-kernel-owner+w=401wt.eu-S1760029AbXF0UWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760029AbXF0UWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 16:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755639AbXF0UWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 16:22:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:36397 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024AbXF0UWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 16:22:40 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Yinghai Lu <Yinghai.Lu@sun.com>
Subject: Re: [PATCH] x86_64: change _map_single to static in pci_gart.c etc
Date: Wed, 27 Jun 2007 22:22:25 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Muli Ben-Yehuda <muli@il.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200706271041.21937.yinghai.lu@sun.com>
In-Reply-To: <200706271041.21937.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706272222.25153.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 June 2007 19:41:21 Yinghai Lu wrote:
> [PATCH] x86_64: change _map_single to static in pci_gart.c etc
> 
> there function is called via dma_ops->.., so change it to static

Actually all these functions shouldn't be inline in the first place.

-Andi
