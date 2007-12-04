Return-Path: <linux-kernel-owner+w=401wt.eu-S1751495AbXLDAzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbXLDAzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 19:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750808AbXLDAzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 19:55:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:44308 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806AbXLDAzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 19:55:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,246,1194249600"; 
   d="scan'208";a="286457202"
Subject: Re: pnpacpi : exceeded the max number of IO resources
From: Shaohua Li <shaohua.li@intel.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: yakui.zhao@intel.com, Chris Holvenstot <cholvenstot@comcast.net>,
       linux-kernel@vger.kernel.org, hidave.darkstar@gmail.com,
       bjorn.helgaas@hp.com, trenn@suse.de, Andrew Morton <akpm@osdl.org>
In-Reply-To: <475436A3.90906@keyaccess.nl>
References: <1196428488.7066.6.camel@localhost>
	 <47508D3C.9050507@keyaccess.nl>  <475436A3.90906@keyaccess.nl>
Content-Type: text/plain
Date: Tue, 04 Dec 2007 08:55:13 +0800
Message-Id: <1196729713.13969.1.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-12-03 at 18:02 +0100, Rene Herman wrote:
> On 30-11-07 23:22, Rene Herman wrote:
> 
> > On 30-11-07 14:14, Chris Holvenstot wrote:
> > 
> >> For what it is worth I too have seen this problem this morning and it
> >> DOES appear to be new (in contrast to a previous comment)
> >>
> >> The message:  pnpacpi: exceeded the max number of mem resources: 12
> >>
> >> is displayed each time the system is booted with the 2.6.24-rc3-git5
> >> kernel but is NOT displayed when booting 2.6.24-rc3-git4
> >>
> >> I have made no changes in my config file between these two kernels other
> >> than to accept any new defaults when running make oldconfig.
> >>
> >> If you had already narrowed it down to a change between git4 and git5 I
> >> apologize for wasting your time.  Have to run to work now.
> > 
> > Thanks, and re-added the proper CCs. Sigh...
> > 
> > Well, yes, the warning is actually new as well. Previously your kernel 
> > just silently ignored 8 more mem resources than it does now it seems.
> > 
> > Given that people are hitting these limits, it might make sense to just 
> > do away with the warning for 2.6.24 again while waiting for the dynamic 
> > code?
> 
> Ping. Should these warnings be reverted for 2.6.24?
Revert the warning doesn't make any sense. I'd suggest changing the IO
resources number bigger till Thomas's patch in.

Shaohua
