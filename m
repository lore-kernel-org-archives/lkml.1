Return-Path: <linux-kernel-owner+w=401wt.eu-S1752985AbZJVILO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbZJVILO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 04:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbZJVILN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 04:11:13 -0400
Received: from mga06.intel.com ([134.134.136.21]:18284 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751007AbZJVILM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 04:11:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,604,1249282800"; 
   d="scan'208";a="562111155"
Date: Thu, 22 Oct 2009 09:57:49 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Peter Ujfalusi <peter.ujfalusi@nokia.com>
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "tony@atomide.com" <tony@atomide.com>,
       "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 1/4] MFD: twl4030: add twl4030_codec MFD as a new child
 to the core
Message-ID: <20091022075748.GA8105@sortiz.org>
References: <1255956140-4829-1-git-send-email-peter.ujfalusi@nokia.com>
 <1255956140-4829-2-git-send-email-peter.ujfalusi@nokia.com>
 <20091021231311.GF17796@sortiz.org>
 <200910220904.32676.peter.ujfalusi@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200910220904.32676.peter.ujfalusi@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 09:04:32AM +0300, Peter Ujfalusi wrote:
> I'll check, if the MFD patch applies to mfd-2.6:for-next also, but to have the 
> soc codec changes the MFD patch should go to the sound-2.6 tree as well to make 
> sure it is not braking things.
> 
> All-in-all, how these things can be handled?
The OMAP patch has been acked by Tony. Then we I'm fine with the mfd one and
Mark is also ok with the remaining asoc one, all 3 patches have to go through
one single tree.

It seems to me that this patchset is mostly an asoc one, even though all of
those patches depend on the MFD one. So I'd perfectly fine if they'd all go
through Mark's tree, and then I'd have to make sure I'm sending my 2.6.33
merge window pull request _after_ Mark's code is in Linus tree. Once it's
there, I can work on merging conflicts with the few twl4030-core pending
patches from my tree. Mark, what do you think ?

Cheers,
Samuel.

 
> Thanks, 
> Péter

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
