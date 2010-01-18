Return-Path: <linux-kernel-owner+w=401wt.eu-S1752578Ab0ARRGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab0ARRGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:06:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960Ab0ARRGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:06:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:52860 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433Ab0ARRGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:06:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,297,1262592000"; 
   d="scan'208";a="765179131"
Subject: Re: [ipw3945-devel] hang on 2.6.33-rc4
From: reinette chatre <reinette.chatre@intel.com>
To: Norbert Preining <preining@logic.at>
Cc: "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100116183056.GA18769@gamma.logic.tuwien.ac.at>
References: <20100115152215.GC2541@gamma.logic.tuwien.ac.at>
	 <1263576588.2751.455.camel@rc-desk>
	 <20100116183056.GA18769@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 09:06:53 -0800
Message-ID: <1263834413.2751.644.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-16 at 10:30 -0800, Norbert Preining wrote:
> On Fr, 15 Jan 2010, reinette chatre wrote:
> > > kernel 2.6.33-rc4
> > > 
> > > I am having repeatable complete hard lockups on my laptop with 2.6.33-rc4.
> > > 2.6.32.3 works fine.
> > > 
> > > I believe that it is related to the network, because sometimes I can
> > > actually log in (gnomes session) and as soon as I do some network
> > > related suddenly hard hang, not even Sysrq working anymore.
> > > 
> > > Interestingly it only happens at a specific AP where the ESSID is
> > > hidden (at work). At home I can work without any problems (ESSID not
> > > hidden).
> > > 
> > > Unfortunately I cannot set up a serial console or similar.
> > 
> > Does that mean no netconsole either? Does anything show up in the logs?
> > Is it easy to reproduce? If so, perhaps you can have increased debug at
> > that time and hopefully something will be captured in the logs when the
> > problem occurs.
> 
> Before I can test this on monday, something else, I just got BUG_ON:
> Jan 17 03:28:58 mithrandir kernel: [34535.207253] iwlagn 0000:06:00.0: iwl_tx_agg_start on ra = 00:0a:79:eb:56:10 tid = 0
> Jan 17 03:28:58 mithrandir kernel: [34535.331218] iwlagn 0000:06:00.0: BUG_ON idx doesn't match seq control idx=139, seq_idx=3435, seq=54960
> Jan 17 03:28:58 mithrandir kernel: [34535.331275] iwlagn 0000:06:00.0: Received BA when not expected
> Jan 17 03:28:58 mithrandir kernel: [34535.331816] iwlagn 0000:06:00.0: BUG_ON idx doesn't match seq control idx=146, seq_idx=3442, seq=55072
> Jan 17 03:28:58 mithrandir kernel: [34535.331915] iwlagn 0000:06:00.0: Received BA when not expected
> Jan 17 03:28:58 mithrandir kernel: [34535.332419] iwlagn 0000:06:00.0: BUG_ON idx doesn't match seq control idx=170, seq_idx=3466, seq=55456
> 
> Actually many many many of these lines.
> 

What you are seeing here is currently being looked into at
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2098 - could you
please add your information there?

Reinette


