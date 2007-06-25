Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbXFYT4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbXFYT4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 15:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbXFYT43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 15:56:29 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:42496 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbXFYT43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 15:56:29 -0400
Date: Mon, 25 Jun 2007 15:56:23 -0400
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86-64: disable the GART in shutdown v2
Message-ID: <20070625195623.GD5334@rhun.ibm.com>
References: <200706221219.16243.yinghai.lu@sun.com> <467C6906.6020105@sun.com> <200706221934.59966.yinghai.lu@sun.com> <200706251234.04548.yinghai.lu@sun.com> <20070625194112.GC5334@rhun.ibm.com> <46801D10.50203@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46801D10.50203@sun.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 12:52:48PM -0700, Yinghai Lu wrote:

> >I suggest include/asm-x86_64/iommu.h for this. proto.h doesn't have
> >anything to do with it.
> 
> move iommu releated to iommu.h and add iommu_ops struct?

That's how I would do it, to complement dma_mapping.h.

Cheers,
Muli
