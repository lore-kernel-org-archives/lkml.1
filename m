Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbXFOQ3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbXFOQ3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 12:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbXFOQ3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 12:29:33 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:9488 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbXFOQ3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 12:29:32 -0400
Date: Fri, 15 Jun 2007 18:29:31 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: jidong xiao <jidong.xiao@gmail.com>
cc: Roland Dreier <rdreier@cisco.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: How to printk unsigned long long variable?
In-Reply-To: <4104961b0706150918me1d809fu66ee07738284c21c@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706151828460.32724@fbirervta.pbzchgretzou.qr>
References: <4104961b0706150759l66fd713boac1a747637e73ee@mail.gmail.com> 
 <19f34abd0706150804w69ce36c0i9e7f9a015895ac0c@mail.gmail.com> 
 <20070615083355.f5bdb784.randy.dunlap@oracle.com> 
 <4104961b0706150839t1a54ccdaq4ddc747d04538a19@mail.gmail.com> 
 <adaabv1i49q.fsf@cisco.com> <4104961b0706150918me1d809fu66ee07738284c21c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 16 2007 00:18, jidong xiao wrote:

> dma_mask should be a pointer, I mean, the element in struct device, see
> below,
>
> struct device {
>
> 	u64		*dma_mask;	/* dma mask (if dma'able device) */

Then it's printk("%llx\n", (unsigned long long)*dev->dma_mask);


	Jan
-- 
