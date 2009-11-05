Return-Path: <linux-kernel-owner+w=401wt.eu-S1758769AbZKETXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769AbZKETXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 14:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758713AbZKETXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 14:23:17 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34624 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758355AbZKETXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 14:23:16 -0500
Date: Thu, 5 Nov 2009 20:23:15 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, stable@kernel.org
Subject: Re: [PATCH 1/4] x86/amd-iommu: Workaround for erratum 63
Message-ID: <20091105192315.GD1392@ucw.cz>
References: <1256835012-31410-1-git-send-email-joerg.roedel@amd.com> <1256835012-31410-2-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256835012-31410-2-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-10-29 17:50:09, Joerg Roedel wrote:
> There is an erratum for IOMMU hardware which documents
> undefined behavior when forwarding SMI requests from
> peripherals and the DTE of that peripheral has a sysmgt
> value of 01b. This problem caused weird IO_PAGE_FAULTS in my
> case.

This should go to comment.

> +
> +
> +void amd_iommu_apply_erratum_63(u16 devid)
> +{
> +	int sysmgt;
> +

...that should go here. Pointer to pdf with erratum would be cool,
too.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
