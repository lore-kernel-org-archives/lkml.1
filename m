Return-Path: <linux-kernel-owner+w=401wt.eu-S1757728AbXENRqC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728AbXENRqC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 13:46:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758001AbXENRpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 13:45:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:36949 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132AbXENRpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 13:45:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,532,1170662400"; 
   d="scan'208";a="227921615"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: PCI bridge range sizing bug
Date: Mon, 14 May 2007 10:45:43 -0700
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Adam Jackson <ajackson@redhat.com>, linux-kernel@vger.kernel.org
References: <1175812632.17147.12.camel@localhost.localdomain> <alpine.LFD.0.98.0704201102000.9964@woody.linux-foundation.org> <20070421003020.A21503@jurassic.park.msu.ru>
In-Reply-To: <20070421003020.A21503@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705141045.44059.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 20, 2007 1:30 pm Ivan Kokshaysky wrote:
> On Fri, Apr 20, 2007 at 11:28:42AM -0700, Linus Torvalds wrote:
> > Actually, I would suggest we not do it automatically (because the
> > need for it is just so low, and the downsides are potentially huge
> > - there are just too many resources that are "hidden" from us
> > through ACPI tricks and having hardware that doesn't actually
> > expose their PCI resources fully through the normal PCI resource
> > setup).
>
> Definitely. I was intending to enable that *only* with some boot
> option.
>
> > Ivan, want to add some way to force that allocation (something like
> > "pci=assign-bus-resources")
>
> Yes, hopefully I'll get something in a next couple of days.

Any update on this, Ivan?  Maybe I missed your post, but I haven't seen 
anything yet...

Thanks,
Jesse
