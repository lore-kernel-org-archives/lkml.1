Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173AbYIAPui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbYIAPui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 11:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbYIAPu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 11:50:29 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:31010 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbYIAPu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 11:50:28 -0400
X-IronPort-AV: E=Sophos;i="4.32,307,1217808000"; 
   d="scan'208";a="98409584"
From: Roland Dreier <rdreier@cisco.com>
To: Alex Chiang <achiang@hp.com>
Cc: "Zhao\, Yu" <yu.zhao@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
       Greg KH <greg@kroah.com>, Grant Grundler <grundler@parisc-linux.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Subject: Re: [PATCH 2/4 v2] PCI: support ARI capability
References: <7A25B56E4BE99C4283EB931CD1A40E110177EB6E@pdsmsx414.ccr.corp.intel.com>
	<20080901152734.GC16796@ldl.fc.hp.com>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 01 Sep 2008 08:50:23 -0700
In-Reply-To: <20080901152734.GC16796@ldl.fc.hp.com> (Alex Chiang's message of
	"Mon, 1 Sep 2008 09:27:34 -0600")
Message-ID: <ada3akjj268.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 01 Sep 2008 15:50:24.0281 (UTC) FILETIME=[72608090:01C90C4A]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > +config PCI_ARI
 > > +	bool "PCI ARI support"
 > > +	depends on PCI
 > > +	default n
 > > +	help
 > > +	  This enables PCI Alternative Routing-ID Interpretation.
 > 
 > This Kconfig help text is a little weak. Why not include the text
 > you've already written here:
 > 
 > 	Support Alternative Routing-ID Interpretation (ARI), which
 > 	increases the number of functions that can be supported by a PCIe
 > 	endpoint. ARI is required by SR-IOV.

I agree with this improvement to the help text.  But a further question
is whether ARI even merits its own user-visible config option.  Is it
worth having yet another choice for users?  When would someone want ARI
but not SR-IOV?

 - R.

