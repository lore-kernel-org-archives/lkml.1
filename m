Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbYACXAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbYACXAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 18:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbYACXAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 18:00:36 -0500
Received: from mga03.intel.com ([143.182.124.21]:49093 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbYACXAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 18:00:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,240,1196668800"; 
   d="scan'208";a="357011351"
Subject: Re: [PATCH] md: Fix data corruption when a degraded raid5 array is
	reshaped.
From: Dan Williams <dan.j.williams@intel.com>
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
In-Reply-To: A<1080103224636.19290@suse.de>
References: <20080104094516.19216.patches@notabene>
	 A<1080103224636.19290@suse.de>
Content-Type: text/plain
Date: Thu, 03 Jan 2008 16:00:34 -0700
Message-Id: <1199401234.9102.3.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-03 at 15:46 -0700, NeilBrown wrote:
> This patch fixes a fairly serious bug in md/raid5 in 2.6.23 and 24-rc.
> It would be great if it cold get into 23.13 and 24.final.
> Thanks.
> NeilBrown
> 
> ### Comments for Changeset
> 
> We currently do not wait for the block from the missing device
> to be computed from parity before copying data to the new stripe
> layout.
> 
> The change in the raid6 code is not techincally needed as we
> don't delay data block recovery in the same way for raid6 yet.
> But making the change now is safer long-term.
> 
> This bug exists in 2.6.23 and 2.6.24-rc
> 
> Cc: stable@kernel.org
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Neil Brown <neilb@suse.de>
> 
Acked-by: Dan Williams <dan.j.williams@intel.com>



