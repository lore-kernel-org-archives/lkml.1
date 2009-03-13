Return-Path: <linux-kernel-owner+w=401wt.eu-S1758912AbZCMR4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912AbZCMR4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbZCMR4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:56:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:35672 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbZCMR4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:56:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,358,1233561600"; 
   d="scan'208";a="672763691"
Subject: Re: [ipw3945-devel] X200 suspend status on -wl and -next
From: reinette chatre <reinette.chatre@intel.com>
To: Nico -telmich- Schottelius 
	<nico-linux-ipw3945-devel@schottelius.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Nico Schottelius <nico-linux-20090311@schottelius.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
       Linux Next Mailing List <linux-next@vger.kernel.org>
In-Reply-To: <20090313080030.GB3246@denkbrett.schottelius.org>
References: <20090311073030.GA5284@denkbrett.schottelius.org>
	 <200903110946.23280.rjw@sisk.pl>
	 <20090311085229.GB4495@denkbrett.schottelius.org>
	 <20090311184407.GG8761@tuxdriver.com>
	 <20090312142003.GF30728@denkbrett.schottelius.org>
	 <20090312173042.GD3410@tuxdriver.com> <1236882742.13699.28.camel@rc-desk>
	 <20090313080030.GB3246@denkbrett.schottelius.org>
Content-Type: text/plain
Date: Fri, 13 Mar 2009 11:01:06 -0700
Message-Id: <1236967266.31798.14.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-13 at 01:00 -0700, Nico -telmich- Schottelius wrote:
> reinette chatre [Thu, Mar 12, 2009 at 11:32:22AM -0700]:
> > On Thu, 2009-03-12 at 10:30 -0700, John W. Linville wrote:
> > > On Thu, Mar 12, 2009 at 03:20:03PM +0100, Nico -telmich- Schottelius wrote:
> > > > John W. Linville [Wed, Mar 11, 2009 at 02:44:07PM -0400]:
> > > > > Any chance you'd like to try wireless-testing to help to isolate
> > > > > possible sources of this problem?
> > > > > 
> > > > > 	git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
> > > > 
> > > > v2.6.29-rc7-17155-g2f7ab92 looks good (as in: wlan works after several
> > > > suspends and resumes). But it seems you do not add the full kernel version:
> > > > 
> > > > sgnx20002:/home/nico/wireless-testing# git describe
> > > > v2.6.29-rc7-17155-g2f7ab92
> > > > sgnx20002:/home/nico/wireless-testing# uname -r
> > > > 2.6.29-rc7-wl-ikn
> > > > 
> > > > Which is the kernel built some seconds before.
> > > 
> > > I don't know where you get the -ikn bits from, presumably from the
> > > iwlwifi project.  Given what you said above, it would seem you are
> > > getting your suspend/resume problems from them as well... :-(
> > 
> > In our repo we do not add anything to the value of localversion. We also
> > track wireless-testing _very_ closely so the differences are at most a
> > handful of patches. Could you please send me commit id of iwlwifi-2.6
> > repo that fails as well as the commit id of wireless-testing repo that
> > succeeds?
> 
> As I did before in this thread:
> 
>   vmlinuz-2.6.29-rc7-wl-ikn-32831-g98c5597 from iwlwifi-2.6: fails
>   2.6.29-rc7-wl-ikn or v2.6.29-rc7-17155-g2f7ab92 from wireless-testing: works

I am sorry that I missed this information in the thread.

> 
> Btw, I'm running 2.6.29-rc7-next-20090306-ikn currently, which also looks good.

Your wireless-testing repository tested is much newer than the
iwlwifi-2.6 one ... new patches for our driver is in your
wireless-testing repo but not in iwlwifi-2.6. So, in your testing
wireless-testing contains more up to date iwlwifi code than the
iwlwifi-2.6 repo.

Could you please test with today's versions of the two repos? There is a
one small patch difference.

Thank you

Reinette


