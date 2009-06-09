Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbZFIOQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbZFIOQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 10:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbZFIOQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 10:16:15 -0400
Received: from sous-sol.org ([216.99.217.87]:35325 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbZFIOQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 10:16:14 -0400
Date: Tue, 9 Jun 2009 07:15:30 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] amd-iommu: remove BUS_NOTIFY_BOUND_DRIVER handling
Message-ID: <20090609141530.GL20823@sequoia.sous-sol.org>
References: <1244555840-3855-1-git-send-email-joerg.roedel@amd.com> <1244555840-3855-3-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244555840-3855-3-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joerg Roedel (joerg.roedel@amd.com) wrote:
> Handling this event causes device assignment in KVM to fail because the
> device gets re-attached as soon as the pci-stub registers as the driver
> for the device.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

Yep, makes good sense, will get picked up from get_device_resources.

Acked-by: Chris Wright <chrisw@sous-sol.org>

thanks,
-chris
