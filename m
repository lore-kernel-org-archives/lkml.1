Return-Path: <linux-kernel-owner+w=401wt.eu-S1752671AbZIMFss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbZIMFss (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 01:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbZIMFsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 01:48:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbZIMFsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 01:48:46 -0400
Date: Sun, 13 Sep 2009 08:46:10 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Xin, Xiaohui" <xiaohui.xin@intel.com>
Cc: "Ira W. Snyder" <iws@ovro.caltech.edu>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "gregory.haskins@gmail.com" <gregory.haskins@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "s.hetze@linux-ag.com" <s.hetze@linux-ag.com>, avi@redhat.com
Subject: Re: [PATCHv5 3/3] vhost_net: a kernel-level virtio server
Message-ID: <20090913054610.GA4446@redhat.com>
References: <cover.1251388414.git.mst@redhat.com> <20090827160750.GD23722@redhat.com> <20090903183945.GF28651@ovro.caltech.edu> <20090907101537.GH3031@redhat.com> <20090908172035.GB319@ovro.caltech.edu> <20090908201428.GA12420@redhat.com> <C85CEDA13AB1CF4D9D597824A86D2B9006AECB9C1D@PDSMSX501.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C85CEDA13AB1CF4D9D597824A86D2B9006AECB9C1D@PDSMSX501.ccr.corp.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11, 2009 at 11:17:33PM +0800, Xin, Xiaohui wrote:
> Michael,
> We are very interested in your patch and want to have a try with it.
> I have collected your 3 patches in kernel side and 4 patches in queue side.
> The patches are listed here:
> 
> PATCHv5-1-3-mm-export-use_mm-unuse_mm-to-modules.patch
> PATCHv5-2-3-mm-reduce-atomic-use-on-use_mm-fast-path.patch
> PATCHv5-3-3-vhost_net-a-kernel-level-virtio-server.patch
> 
> PATCHv3-1-4-qemu-kvm-move-virtio-pci[1].o-to-near-pci.o.patch
> PATCHv3-2-4-virtio-move-features-to-an-inline-function.patch
> PATCHv3-3-4-qemu-kvm-vhost-net-implementation.patch
> PATCHv3-4-4-qemu-kvm-add-compat-eventfd.patch
> 
> I applied the kernel patches on v2.6.31-rc4 and the qemu patches on latest kvm qemu.
> But seems there are some patches are needed at least irqfd and ioeventfd patches on
> current qemu. I cannot create a kvm guest with "-net nic,model=virtio,vhost=vethX".
> 
> May you kindly advice us the patch lists all exactly to make it work?
> Thanks a lot. :-)
> 
> Thanks
> Xiaohui


The irqfd/ioeventfd patches are part of Avi's kvm.git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git

I expect them to be merged by 2.6.32-rc1 - right, Avi?

-- 
MST
