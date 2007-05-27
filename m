Return-Path: <linux-kernel-owner+w=401wt.eu-S1759776AbXE0VB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759776AbXE0VB4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 17:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756402AbXE0VBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 17:01:46 -0400
Received: from mail.gmx.net ([213.165.64.20]:50049 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755512AbXE0VBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 17:01:45 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/7T11LjbX7d5gd8I8iFp8pegpQ80Uby/D/1OrGV3
	Fia1R6KqBdGu4q
Date: Sun, 27 May 2007 23:01:46 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
cc: Auke Kok <auke-jan.h.kok@intel.com>, randy.dunlap@oracle.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [condingstyle] Add chapter on tests
In-Reply-To: <Pine.LNX.4.61.0705262213000.7344@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.60.0705272256240.4530@poirot.grange>
References: <20070525172509.5138.56430.stgit@localhost.localdomain>
 <20070525172515.5138.13652.stgit@localhost.localdomain>
 <Pine.LNX.4.61.0705262121150.7344@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0705262213000.7344@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 May 2007, Jan Engelhardt wrote:

> +Testing for a flag, as done in the following example, is redundant and
> +can be shortened.
> +
> +	if ((v & GFP_KERNEL) == GFP_KERNEL)
> +		return;
> +
> +should become
> +
> +	if (v & GFP_KERNEL)
> +		return;

This looks wrong to me. These two are only equivalent if the "flag" only 
has 1 bit. And already here you fall into this trap:

#define GFP_KERNEL	(__GFP_WAIT | __GFP_IO | __GFP_FS)

Thanks
Guennadi
---
Guennadi Liakhovetski
