Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbZJVLC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbZJVLC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 07:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbZJVLC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 07:02:27 -0400
Received: from smtp.nokia.com ([192.100.122.230]:59744 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbZJVLC0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 07:02:26 -0400
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: ext Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 1/4] MFD: twl4030: add twl4030_codec MFD as a new child to the core
Date: Thu, 22 Oct 2009 14:02:08 +0300
User-Agent: KMail/1.12.2 (Linux/2.6.31-gentoo; KDE/4.3.2; i686; ; )
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "tony@atomide.com" <tony@atomide.com>
References: <1255956140-4829-1-git-send-email-peter.ujfalusi@nokia.com> <20091022075748.GA8105@sortiz.org> <20091022105517.GB18862@rakim.wolfsonmicro.main>
In-Reply-To: <20091022105517.GB18862@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200910221402.08837.peter.ujfalusi@nokia.com>
X-OriginalArrivalTime: 22 Oct 2009 11:02:13.0905 (UTC) FILETIME=[1C5A8010:01CA5307]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 October 2009 13:55:17 ext Mark Brown wrote:
> On Thu, Oct 22, 2009 at 09:57:49AM +0200, Samuel Ortiz wrote:
> > It seems to me that this patchset is mostly an asoc one, even though all
> > of those patches depend on the MFD one. So I'd perfectly fine if they'd
> > all go through Mark's tree, and then I'd have to make sure I'm sending my
> > 2.6.33 merge window pull request _after_ Mark's code is in Linus tree.
> > Once it's there, I can work on merging conflicts with the few
> > twl4030-core pending patches from my tree. Mark, what do you think ?
> 
> Seems reasonable.  I'll apply them on a separate branch and merge them
> into my 2.6.33 branch so that you can merge them into your tree too and
> avoid any cross-tree issues without needing to think about how things
> get merged with Linus (though since Takashi generally merges early it'll
> probably happen naturally anyway).  Note that if you do pull this branch
> you won't be able to rebase your tree, you'd have to merge up Linus'
> tree instead (but that'd be handy anyway :) ).

I just sent the second series, I'll hope the I have not missed anything. 
I was scratching my head on which tree it should be going, but it is really nice 
to see that it can be done like this.
Thank you Samuel, Mark and Tony!

-- 
Péter
