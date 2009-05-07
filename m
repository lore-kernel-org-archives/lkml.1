Return-Path: <linux-kernel-owner+w=401wt.eu-S1762530AbZEGJfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762530AbZEGJfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762817AbZEGJeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:34:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34044 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762811AbZEGJeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:34:15 -0400
Date: Thu, 7 May 2009 12:31:37 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sheng Yang <sheng@linux.intel.com>
Cc: kvm@vger.kernel.org, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>,
       virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] msi-x: let drivers retry when not enough vectors
Message-ID: <20090507093137.GD32039@redhat.com>
References: <20090507082841.GA31751@redhat.com> <200905071651.24970.sheng@linux.intel.com> <20090507090506.GB32039@redhat.com> <200905071710.47204.sheng@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905071710.47204.sheng@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 05:10:46PM +0800, Sheng Yang wrote:
> > > I think driver should read from capability list to know how many vector
> > > supported by this device before enable MSI-X for device, as
> > > pci_msix_table_size() did...
> >
> > Drivers can do this, but it's more code. Since pci_enable_msix
> > calls pci_msix_table_size already, let it do the work. Right?
> 
> If you don't know the vectors number before you enable MSI-X, how can you 
> setup vectors? 

I don't know how many irqs I will be able to get anyway.
vectors that can't be assigned are useless ...

-- 
MST
