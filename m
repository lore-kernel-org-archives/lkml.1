Return-Path: <linux-kernel-owner+w=401wt.eu-S1753207AbZBQM21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbZBQM21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 07:28:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbZBQM2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 07:28:15 -0500
Received: from stinky.trash.net ([213.144.137.162]:54836 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbZBQM2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 07:28:14 -0500
Message-ID: <499AAD5B.8060706@trash.net>
Date: Tue, 17 Feb 2009 13:28:11 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Karl Hiramoto <karl@hiramoto.org>
CC: Jarek Poplawski <jarkao2@gmail.com>, netdev@vger.kernel.org,
       netfilter@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: problem with IPoA (CLIP),  NAT, and VLANS
References: <20090216232016.GA4803@ami.dom.local> <499AA433.8070308@hiramoto.org>
In-Reply-To: <499AA433.8070308@hiramoto.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karl Hiramoto wrote:
> What Patrick,  said may be the case,  that the underlaying atm driver is
> not specifying the headroom.   The driver is ported to 2.6.28 from
> 2.6.11 based on the BSD licensed intel libaries:
> http://www.intel.com/design/network/products/npfamily/download_ixp400.htm

If those are the ones I think they are, I'm not too surprised ...

> Where underneath a bunch of layers the skb is allocated with kmalloc like:
> 
> size = PAGE_ALIGN (size + CACHE_LINE_SIZE);
> order = get_order (size);
> page = alloc_pages (GFP_KERNEL, order);

How does it initialize the netdev struct?

