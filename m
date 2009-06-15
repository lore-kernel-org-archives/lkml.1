Return-Path: <linux-kernel-owner+w=401wt.eu-S1763712AbZFOQeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763712AbZFOQeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 12:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757279AbZFOQe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 12:34:29 -0400
Received: from sous-sol.org ([216.99.217.87]:50292 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757926AbZFOQe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 12:34:29 -0400
Date: Mon, 15 Jun 2009 09:33:51 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Chris Wright <chrisw@sous-sol.org>, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] amd-iommu: kdump bugfix and couple defensive
	cleanups
Message-ID: <20090615163351.GB30071@sequoia.sous-sol.org>
References: <20090612030341.GQ20823@sequoia.sous-sol.org> <20090615094848.GD5139@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615094848.GD5139@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joerg Roedel (joerg.roedel@amd.com) wrote:
> On Thu, Jun 11, 2009 at 08:03:41PM -0700, Chris Wright wrote:
> > The following patches fix a kdump issue and then fix some similar
> > initialization issues that haven't proven to be problematic but make
> > good sense anyway.
> 
> The patches look good but are based on 2.6.30. For 2.6.31-rc1 they must
> be changed a bit because some functions implemented in these patches
> were already merged for the suspen/resume support in amd-iommu driver.
> I will adapt them for 2.6.31. Do you want to send these patches for
> -stable inclusion?

Yes, I meant to mark at least 1/2 "Cc: stable@kernel.org".

thanks,
-chris
