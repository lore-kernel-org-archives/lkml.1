Return-Path: <linux-kernel-owner+w=401wt.eu-S1753818AbYI3L6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbYI3L6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 07:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbYI3L6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 07:58:43 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:39978 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbYI3L6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 07:58:42 -0400
X-BigFish: VPS-29(zz1432R98dR1805M936fOzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K80BX7-04-XPG-01
Date: Tue, 30 Sep 2008 13:58:18 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, David Woodhouse <dwmw2@infradead.org>,
       Muli Ben-Yehuda <muli@il.ibm.com>, Amit Shah <amit.shah@qumranet.com>,
       Ingo Molnar <mingo@redhat.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 6/9] x86/iommu: change Calgary to use dma_ops register interface
Message-ID: <20080930115818.GO27928@amd.com>
References: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com> <1222107681-8185-7-git-send-email-joerg.roedel@amd.com> <20080930111028.GC12529@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080930111028.GC12529@elte.hu>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 30 Sep 2008 11:58:19.0021 (UTC) FILETIME=[D44133D0:01C922F3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 01:10:28PM +0200, Ingo Molnar wrote:
> 
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > +static int calgary_device_supported(struct device *dev)
> > +{
> > +	struct iommu_table *tbl;
> > +
> > +	tbl = find_iommu_table(dev);
> > +
> > +	return translation_enabled(tbl);
> > +}
> 
> i guess this could be written as a simple:
> 
> > +static int calgary_device_supported(struct device *dev)
> > +{
> > +	return translation_enabled(find_iommu_table(dev));
> > +}
> 
> ?

Yes. I will change it.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

