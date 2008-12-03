Return-Path: <linux-kernel-owner+w=401wt.eu-S1752865AbYLCGGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbYLCGGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 01:06:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbYLCGG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 01:06:27 -0500
Received: from ns1.suse.de ([195.135.220.2]:34830 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655AbYLCGG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 01:06:26 -0500
Date: Tue, 2 Dec 2008 19:44:05 -0800
From: Greg KH <gregkh@suse.de>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>, Alexander Graf <agraf@suse.de>,
       Han Weidong <weidong.han@intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 0/12] Factor VT-d KVM functions into a generic API
	(with multiple device assignment support)
Message-ID: <20081203034405.GA23835@suse.de>
References: <1228222883-17207-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228222883-17207-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2008 at 02:01:11PM +0100, Joerg Roedel wrote:
> Hi,
> 
> this patch series makes the current KVM device passthrough code generic
> enough so that other IOMMU implementation can also plug into this code.
> It works by factoring the functions Vt-d code exports to KVM into a
> generic interface which allows different backends.
> 
> This is the second version of the patchset. The most important change to
> the previous version is that this patchset was rebased to the improved
> API from Han Weidong which supports multiple devices per IOMMU domain.
> 
> For completeness, this series also includes the patches from Han with
> some cleanups. So this patchset can be applied on current avi/master
> tree.

Have you tried porting any of the current iommu controllers to this new
framework to see if it works properly for them?

thanks,

greg k-h
