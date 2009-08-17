Return-Path: <linux-kernel-owner+w=401wt.eu-S1758352AbZHQXaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352AbZHQXaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 19:30:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbZHQXaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 19:30:12 -0400
Received: from sous-sol.org ([216.99.217.87]:51649 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751214AbZHQXaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 19:30:11 -0400
Date: Mon, 17 Aug 2009 16:29:37 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Faidon Liambotis <paravoid@debian.org>
Cc: Chris Wright <chrisw@sous-sol.org>, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org,
       David Woodhouse <David.Woodhouse@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [regression, bisected] fails to boot on Dell Optiplex 760 with
	VT-d enabled
Message-ID: <20090817232937.GK24885@sequoia.sous-sol.org>
References: <4A89CB52.4030008@debian.org> <20090817231156.GJ24885@sequoia.sous-sol.org> <4A89E63E.407@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A89E63E.407@debian.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Faidon Liambotis (paravoid@debian.org) wrote:
> As an observation, David's patch is checking if *both* iommu->cap and
> iommu->ecap are -1, while yours checks for either. You're also checking
> for ver. Obviously, I have no idea which of the two is more correct.

David's looks fine to me, and as a bonus it's already queued up ;-)
None of those registers should return -1.

thanks,
-chris
