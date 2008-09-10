Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbYIJSmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbYIJSmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 14:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbYIJSmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 14:42:22 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:10116 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbYIJSmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 14:42:20 -0400
From: Roland Dreier <rdreier@cisco.com>
To: "Zhao\, Yu" <yu.zhao@intel.com>
Cc: "Alex Chiang" <achiang@hp.com>, "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       <linux-pci@vger.kernel.org>, "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Greg KH" <greg@kroah.com>,
       "Grant Grundler" <grundler@parisc-linux.org>,
       "Matthew Wilcox" <matthew@wil.cx>, <linux-kernel@vger.kernel.org>,
       <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
       <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 2/4 v2] PCI: support ARI capability
References: <7A25B56E4BE99C4283EB931CD1A40E110177EB6E@pdsmsx414.ccr.corp.intel.com>
	<20080901152734.GC16796@ldl.fc.hp.com> <ada3akjj268.fsf@cisco.com>
	<7A25B56E4BE99C4283EB931CD1A40E110181CAF7@pdsmsx414.ccr.corp.intel.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 10 Sep 2008 11:42:18 -0700
In-Reply-To: <7A25B56E4BE99C4283EB931CD1A40E110181CAF7@pdsmsx414.ccr.corp.intel.com>
	(Yu Zhao's message of "Wed, 10 Sep 2008 15:48:04 +0800")
Message-ID: <aday71zn8qd.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Sep 2008 18:42:18.0675 (UTC) FILETIME=[F3F3E030:01C91374]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > ARI is an independent PCI Express extended capability. Multi-function
 > devices supporting this capability may use it to track dependency
 > between different functions and assign function group numbers to
 > these functions.

 > Another reason to keep this separated with SR-IOV is that after ARI
 > is enabled, PCI Express Endpoint may have non-zero slot number
 > (device number), which is different from traditional PCI Express
 > Endpoint.

OK, I guess.  Although I still don't see why we need a user-visible
option to control ARI independent of SR-IOV.  When would a user want to
enable CONFIG_PCI_ARI=y but not select CONFIG_PCI_IOV?  (Also, by the
way, why PCI_IOV instead of PCI_SR_IOV -- I assume in the future we may
have PCI_MR_IOV, and matching the PCI terminology is probably easier for
people to understand).

 - R.
