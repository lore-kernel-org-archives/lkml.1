Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab0APSbP (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 13:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755925Ab0APSbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 13:31:14 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:60180 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab0APSbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 13:31:11 -0500
Date: Sat, 16 Jan 2010 19:30:56 +0100
To: reinette chatre <reinette.chatre@intel.com>
Cc: "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [ipw3945-devel] hang on 2.6.33-rc4
Message-ID: <20100116183056.GA18769@gamma.logic.tuwien.ac.at>
References: <20100115152215.GC2541@gamma.logic.tuwien.ac.at> <1263576588.2751.455.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263576588.2751.455.camel@rc-desk>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fr, 15 Jan 2010, reinette chatre wrote:
> > kernel 2.6.33-rc4
> > 
> > I am having repeatable complete hard lockups on my laptop with 2.6.33-rc4.
> > 2.6.32.3 works fine.
> > 
> > I believe that it is related to the network, because sometimes I can
> > actually log in (gnomes session) and as soon as I do some network
> > related suddenly hard hang, not even Sysrq working anymore.
> > 
> > Interestingly it only happens at a specific AP where the ESSID is
> > hidden (at work). At home I can work without any problems (ESSID not
> > hidden).
> > 
> > Unfortunately I cannot set up a serial console or similar.
> 
> Does that mean no netconsole either? Does anything show up in the logs?
> Is it easy to reproduce? If so, perhaps you can have increased debug at
> that time and hopefully something will be captured in the logs when the
> problem occurs.

Before I can test this on monday, something else, I just got BUG_ON:
Jan 17 03:28:58 mithrandir kernel: [34535.207253] iwlagn 0000:06:00.0: iwl_tx_agg_start on ra = 00:0a:79:eb:56:10 tid = 0
Jan 17 03:28:58 mithrandir kernel: [34535.331218] iwlagn 0000:06:00.0: BUG_ON idx doesn't match seq control idx=139, seq_idx=3435, seq=54960
Jan 17 03:28:58 mithrandir kernel: [34535.331275] iwlagn 0000:06:00.0: Received BA when not expected
Jan 17 03:28:58 mithrandir kernel: [34535.331816] iwlagn 0000:06:00.0: BUG_ON idx doesn't match seq control idx=146, seq_idx=3442, seq=55072
Jan 17 03:28:58 mithrandir kernel: [34535.331915] iwlagn 0000:06:00.0: Received BA when not expected
Jan 17 03:28:58 mithrandir kernel: [34535.332419] iwlagn 0000:06:00.0: BUG_ON idx doesn't match seq control idx=170, seq_idx=3466, seq=55456

Actually many many many of these lines.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan            TU Wien, Austria           Debian TeX Task Force
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
LARGOWARD (n.)
Motorists' name for the kind of pedestrian who stands beside a main
road and waves on the traffic, as if it's their right of way.
			--- Douglas Adams, The Meaning of Liff
