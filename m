Return-Path: <linux-kernel-owner+w=401wt.eu-S937925AbXG0WU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937925AbXG0WU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 18:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbXG0WUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 18:20:20 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:36309
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbXG0WUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 18:20:19 -0400
Date: Fri, 27 Jul 2007 15:20:06 -0700
To: Tong Li <tong.n.li@intel.com>
Cc: Chris Snook <csnook@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
Message-ID: <20070727222005.GD32582@gnuppy.monkey.org>
References: <20070725110159.GA15076@elte.hu> <20070725120358.GA30755@elte.hu> <Pine.LNX.4.64.0707251014520.14515@tongli.jf.intel.com> <20070725192442.GC4463@elte.hu> <Pine.LNX.4.64.0707261123060.9352@tongli.jf.intel.com> <20070726213154.GA26569@elte.hu> <1185487225.3122.11.camel@tongli.jf.intel.com> <Pine.LNX.4.64.0707261806450.5321@tongli.jf.intel.com> <46AA287D.8070200@redhat.com> <Pine.LNX.4.64.0707271159420.12201@tongli.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707271159420.12201@tongli.jf.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2007 at 12:03:28PM -0700, Tong Li wrote:
> Thanks for the interest. Attached is a design doc I wrote several months 
> ago (with small modifications). It talks about the two pieces of my design: 
> group scheduling and dwrr. The description was based on the original O(1) 
> scheduler, but as my CFS patch showed, the algorithm is applicable to other 
> underlying schedulers as well. It's interesting that I started working on 
> this in January for the purpose of eventually writing a paper about it. So 
> I knew reasonably well the related research work but was totally unaware 
> that people in the Linux community were also working on similar things. 
> This is good. If you are interested, I'd like to help with the algorithms 
> and theory side of the things.

Tong,

This is sufficient as an overview of the algorithm but not detailed enough
for it to be a discussable design doc I believe. You should ask Chris to see
what he means by this.

Some examples of your rebalancing scheme and how your invariant applies
across processor rounds would be helpful for me and possibly others as well.

bill

