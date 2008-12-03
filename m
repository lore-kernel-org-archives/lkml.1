Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505AbYLCHvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbYLCHvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 02:51:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYLCHuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 02:50:52 -0500
Received: from 8bytes.org ([88.198.83.132]:57921 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315AbYLCHuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 02:50:51 -0500
Date: Wed, 3 Dec 2008 08:50:49 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Greg KH <gregkh@suse.de>
Cc: Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org,
       Han Weidong <weidong.han@intel.com>, linux-kernel@vger.kernel.org,
       Alexander Graf <agraf@suse.de>, iommu@lists.linux-foundation.org,
       Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 0/12] Factor VT-d KVM functions into a generic API (with multiple device assignment support)
Message-ID: <20081203075049.GN29705@8bytes.org>
References: <1228222883-17207-1-git-send-email-joerg.roedel@amd.com> <20081203034405.GA23835@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081203034405.GA23835@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2008 at 07:44:05PM -0800, Greg KH wrote:
> On Tue, Dec 02, 2008 at 02:01:11PM +0100, Joerg Roedel wrote:
> > Hi,
> > 
> > this patch series makes the current KVM device passthrough code generic
> > enough so that other IOMMU implementation can also plug into this code.
> > It works by factoring the functions Vt-d code exports to KVM into a
> > generic interface which allows different backends.
> > 
> > This is the second version of the patchset. The most important change to
> > the previous version is that this patchset was rebased to the improved
> > API from Han Weidong which supports multiple devices per IOMMU domain.
> > 
> > For completeness, this series also includes the patches from Han with
> > some cleanups. So this patchset can be applied on current avi/master
> > tree.
> 
> Have you tried porting any of the current iommu controllers to this new
> framework to see if it works properly for them?

It works currently for VT-d. I also port it to AMD IOMMU currently. With
some extensions (offset for start address, flags and size limitation) it
is also suitable for IOMMUs like GART or similar ones.

Joerg
