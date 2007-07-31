Return-Path: <linux-kernel-owner+w=401wt.eu-S1759229AbXGaRDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759229AbXGaRDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 13:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbXGaRD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 13:03:29 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:38540 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193AbXGaRD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 13:03:27 -0400
Subject: RE: regression on HP zx1 platform from ACPI autoload modulespatches
From: Doug Chapman <doug.chapman@hp.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Tony Luck <tony.luck@gmail.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-ia64@vger.kernel.org, trenn@suse.de
In-Reply-To: <617E1C2C70743745A92448908E030B2A020E3AD2@scsmsx411.amr.corp.intel.com>
References: <617E1C2C70743745A92448908E030B2A020E3AD2@scsmsx411.amr.corp.intel.com>
Content-Type: text/plain
Date: Tue, 31 Jul 2007 12:59:56 -0400
Message-Id: <1185901196.4478.16.camel@deimos.americas.hpqcorp.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 09:29 -0700, Luck, Tony wrote:
> > commit 8c8eb78f673c07b60f31751e1e47ac367c60c6b7
> 
> Oops.  I cut & pasted the wrong commit id.  The fix went in as
> commit 7091138fb762aed22317b4ff91eb211e7da3865c.
> 
> > FYI, I did a git pull yesterday just before I hit this issue so I should
> > have had the latest stuff.
> 
> So this confuses me.  Linus pulled this into his tree on Friday (IIRC), but
> at the very latest on Saturday (as there is a commit *after* this one that
> is dated 2007-07-28 19:29:37).
> 
> The patch that is in the tree appears to be identical to the one that
> Thomas Renninger posted to this thread, and you confirmed as working.
> 
> So when you have a moment, please pull latest Linus tree.  Confirm that
> this patch is present:
>  $ grep hp_ioc_iommu_device_ids arch/ia64/hp/common/sba_iommu.c
>  static const struct acpi_device_id hp_ioc_iommu_device_ids[] = {
>  	.ids		= hp_ioc_iommu_device_ids,
>  $
> 
> and that it builds and boots for you.
> 
> Thanks
> 
> -Tony
>  

Tony, all,

I think I have solved the mystery.  I have my git tree pointing to
git.frob.com to try to lessen the load on kernel.org.  I am guessing
that the last time I pulled linus's tree from there they had not pulled
since the commit was made so I was still a little out of date.

The latest git pull now does indeed grab this commit.

sorry for any confusion I may have caused.

- Doug


