Return-Path: <linux-kernel-owner+w=401wt.eu-S1161106AbXBMH2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161106AbXBMH2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 02:28:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbXBMH2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 02:28:45 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:24002
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751158AbXBMH2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 02:28:45 -0500
Message-Id: <45D17660.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Tue, 13 Feb 2007 07:27:12 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Christoph Hellwig" <hch@lst.de>
Cc: <tony.luck@intel.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [IA64] swiotlb abstraction (e.g. for Xen)
References: <200702070759.l177xIti030295@hera.kernel.org>
 <20070207083254.GA24561@lst.de> <20070211072555.GA22831@lst.de>
 <45D025BF.76E4.0078.0@novell.com> <20070212171224.GA18430@lst.de>
In-Reply-To: <20070212171224.GA18430@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Christoph Hellwig <hch@lst.de> 12.02.07 18:12 >>>
>On Mon, Feb 12, 2007 at 07:30:55AM +0000, Jan Beulich wrote:
>> 
>> As the topic says - the goal is to support Xen. But yes, I was afraid someone would
>> claim this make the code look ugly. And no, I currently don't have ideas to address
>> any of your comments without breaking functionality on Xen...
>
>We don't have Xen merged, and it doesn't look like we're going to get it
>soon.  Also the code is only for dom0 which will take even longer.
>At this point I'm pretty sure the code is cleaner, simpler and easier to
>maintain if you just split out a xendom0swiotlb instead of messing up
>the existing code.

We have such a file, and the purpose of the patch was to get rid of it.

Jan
