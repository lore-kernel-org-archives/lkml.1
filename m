Return-Path: <linux-kernel-owner+w=401wt.eu-S1757587AbYCYWxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbYCYWxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 18:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754270AbYCYWxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 18:53:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:64707 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149AbYCYWxg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 18:53:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,555,1199692800"; 
   d="scan'208";a="539928282"
X-MIMEOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [Patch 0/5] prepare XPC and XPNET to support SGI UV
Date: Tue, 25 Mar 2008 15:49:46 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843ECE9E1AB@orsmsx424.amr.corp.intel.com>
In-reply-to: <20080325201423.GB4446@sgi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Patch 0/5] prepare XPC and XPNET to support SGI UV
Thread-Index: AciOtN6ijiLlfNR2Sj6aAoCZFjWJPgAEPBvQ
References: <20080325192524.343385569@attica.americas.sgi.com> <20080325201423.GB4446@sgi.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Dean Nelson" <dcn@sgi.com>, <jes@sgi.com>, <linux-kernel@vger.kernel.org>,
       <linux-ia64@vger.kernel.org>
X-OriginalArrivalTime: 25 Mar 2008 22:49:47.0335 (UTC) FILETIME=[86A1D570:01C88ECA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 02:25:24PM -0500, dcn@sgi.com wrote:
> This set of five patches moves XPC and XPNET to drivers/misc/xp in preparation
> for enabling X86_64 support.

Part 2 (which I got since you addressed it to me directly as well as
to the list) has a couple of "Space in indent is follwed by a tab"
complaints from GIT.  Part 3 has one too.  Apart from that all five
parts apply and the build is clean on all my configs.  Boots on the
tiger (but this doesn't constitute a review ... just a "you didn't
break anything unrelated while making this change").

> The missing patch moved XPC and XPNET from arch/ia64/sn to drivers/misc/xp.
> How should such a patch be submitted?

I think git has an option to produce its own brand of diff output
that lists the renames without doing a full remove & add which is
needed for patch(1) comprehensibility.  A few minutes staring at
git documentation hasn't revealed what that option is though :-(

For purposes of getting someone to review ... you could hand edit
to show the renames as:

	$ mv arch/ia64/sn/kernel/xpc_channel.c drivers/misc/xp/xpc_channel.c
		... etc.

and just include the diffs for the Makefiles, Kconfig etc.

Or break part 2 into:

	2a - remove driver from arch/ia64
	2b - add driver to drivers/misc/xp

-Tony
