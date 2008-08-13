Return-Path: <linux-kernel-owner+w=401wt.eu-S1757474AbYHMSZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbYHMSZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 14:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbYHMSZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 14:25:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49089 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbYHMSZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 14:25:05 -0400
Message-ID: <48A3260F.4000702@zytor.com>
Date: Wed, 13 Aug 2008 11:21:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, riel@redhat.com, greg@kroah.com,
       tytso@mit.edu, viro@ZenIV.linux.org.uk, arjan@infradead.org,
       alan@lxorguk.ukuu.org.uk, peterz@infradead.org, hch@infradead.org
Subject: Re: TALPA - a threat model?  well sorta.
References: <1218645375.3540.71.camel@localhost.localdomain> <20080813181714.GL1366@one.firstfloor.org>
In-Reply-To: <20080813181714.GL1366@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> This means you need significant LSM components simply to protect
> the integrity of the file scanner against root. It's even 
> unclear it's possible in the general case (e.g. X server doing
> arbitary DMA and no IOMMU -- how do you protect the file scanner?)
> 

Without Treacherous Computing, it isn't possible, even in kernel space.

In Treacherous Computing you can put it in the hypervisor, which of 
course just means the hypervisor is now much bigger and likely to 
contain security holes.

	-hpa
