Return-Path: <linux-kernel-owner+w=401wt.eu-S1759255AbZIPPQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255AbZIPPQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 11:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759222AbZIPPQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 11:16:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755116AbZIPPQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 11:16:47 -0400
Date: Wed, 16 Sep 2009 18:13:29 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Gregory Haskins <gregory.haskins@gmail.com>, Avi Kivity <avi@redhat.com>,
       "Ira W. Snyder" <iws@ovro.caltech.edu>, netdev@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, linux-mm@kvack.org,
       akpm@linux-foundation.org, hpa@zytor.com,
       Rusty Russell <rusty@rustcorp.com.au>, s.hetze@linux-ag.com,
       alacrityvm-devel@lists.sourceforge.net
Subject: Re: [PATCHv5 3/3] vhost_net: a kernel-level virtio server
Message-ID: <20090916151329.GC5513@redhat.com>
References: <20090914164750.GB3745@redhat.com> <4AAFFC8E.9010404@gmail.com> <20090915212545.GC27954@redhat.com> <200909161657.42628.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909161657.42628.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 04:57:42PM +0200, Arnd Bergmann wrote:
> On Tuesday 15 September 2009, Michael S. Tsirkin wrote:
> > Userspace in x86 maps a PCI region, uses it for communication with ppc?
> 
> This might have portability issues. On x86 it should work, but if the
> host is powerpc or similar, you cannot reliably access PCI I/O memory
> through copy_tofrom_user but have to use memcpy_toio/fromio or readl/writel
> calls, which don't work on user pointers.
> 
> Specifically on powerpc, copy_from_user cannot access unaligned buffers
> if they are on an I/O mapping.
> 
> 	Arnd <><

We are talking about doing this in userspace, not in kernel.

-- 
MST
