Return-Path: <linux-kernel-owner+w=401wt.eu-S1754909AbZJVKzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbZJVKzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 06:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbZJVKzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 06:55:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47152 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754434AbZJVKzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 06:55:14 -0400
Date: Thu, 22 Oct 2009 11:55:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "tony@atomide.com" <tony@atomide.com>
Subject: Re: [PATCH 1/4] MFD: twl4030: add twl4030_codec MFD as a new child
 to the core
Message-ID: <20091022105517.GB18862@rakim.wolfsonmicro.main>
References: <1255956140-4829-1-git-send-email-peter.ujfalusi@nokia.com>
 <1255956140-4829-2-git-send-email-peter.ujfalusi@nokia.com>
 <20091021231311.GF17796@sortiz.org>
 <200910220904.32676.peter.ujfalusi@nokia.com>
 <20091022075748.GA8105@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091022075748.GA8105@sortiz.org>
X-Cookie: 10.0 times 0.1 is hardly ever 1.0.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 09:57:49AM +0200, Samuel Ortiz wrote:

> It seems to me that this patchset is mostly an asoc one, even though all of
> those patches depend on the MFD one. So I'd perfectly fine if they'd all go
> through Mark's tree, and then I'd have to make sure I'm sending my 2.6.33
> merge window pull request _after_ Mark's code is in Linus tree. Once it's
> there, I can work on merging conflicts with the few twl4030-core pending
> patches from my tree. Mark, what do you think ?

Seems reasonable.  I'll apply them on a separate branch and merge them
into my 2.6.33 branch so that you can merge them into your tree too and
avoid any cross-tree issues without needing to think about how things
get merged with Linus (though since Takashi generally merges early it'll
probably happen naturally anyway).  Note that if you do pull this branch
you won't be able to rebase your tree, you'd have to merge up Linus'
tree instead (but that'd be handy anyway :) ).
