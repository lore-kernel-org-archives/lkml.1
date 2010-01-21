Return-Path: <linux-kernel-owner+w=401wt.eu-S1751834Ab0AUA2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab0AUA2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 19:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335Ab0AUA2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 19:28:15 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:57534 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab0AUA2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 19:28:10 -0500
Date: Thu, 21 Jan 2010 01:28:01 +0100
To: Zhu Yi <yi.zhu@intel.com>, Johannes Berg <johannes@sipsolutions.net>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>
Subject: Re: [ipw3945-devel] hang on 2.6.33-rc4
Message-ID: <20100121002801.GA9738@gamma.logic.tuwien.ac.at>
References: <1263576588.2751.455.camel@rc-desk> <20100119054715.GA10780@gamma.logic.tuwien.ac.at> <1263920481.4838.32.camel@rchatre-DESK> <1263923990.28066.3.camel@johannes.local> <20100120003603.GB21011@gamma.logic.tuwien.ac.at> <1263981160.9171.5.camel@johannes.local> <20100115152215.GC2541@gamma.logic.tuwien.ac.at> <1263576588.2751.455.camel@rc-desk> <20100119054715.GA10780@gamma.logic.tuwien.ac.at> <1263979965.10275.2.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263981160.9171.5.camel@johannes.local> <1263979965.10275.2.camel@debian>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

On Mi, 20 Jan 2010, Zhu Yi wrote:
> Looks like this this is the BUG_ON in skb_pull. Please try if this patch
> help? BTW, are you using swiotlb?

On Mi, 20 Jan 2010, Johannes Berg wrote:
> > # CONFIG_FRAME_POINTER is not set
> 
> The stacktrace would be a lot more useful with it set, yes. Other than
> that, I don't know. If there's a way to make your display resolution
> higher that might be useful so more info fits on the screen, or maybe
> trimming the stack trace depth (though I don't know if that's possible,
> I do know it is on powerpc because I added it there but not sure on x86)
> 
> All assuming you can reproduce this issue, of course.


@Zhu: the patch didn't help. I patched it into the kernel plus activated
CONFIG_FRAME_POINTER which led to the same hang (not surprisingly, the
patch does only debug more ;-)

This time unfortunately I there was too much output to actually capture it.

@Johannes: 100% reproducible. Everytime I boot into 33-rc4 and ssh into
any remote place it goes boom. 100%.

Maybe another tidbig might help: With 2.6.32.3 it happens that I have
hickups with WLAN:
[  996.514491] iwlagn 0000:06:00.0: iwl_tx_agg_start on ra = 00:24:c4:ab:bb:42 tid = 0
and the connections needs 10-20secs (hard to guess) until it is
back alive.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan            TU Wien, Austria           Debian TeX Task Force
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
AITH (n.)
The single bristle that sticks out sideways on a cheap paintbrush.
			--- Douglas Adams, The Meaning of Liff
