Return-Path: <linux-kernel-owner+w=401wt.eu-S1754443AbYI3Wkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbYI3Wkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 18:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbYI3WkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 18:40:20 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:42141 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbYI3WkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 18:40:18 -0400
X-IronPort-AV: E=Sophos;i="4.33,340,1220227200"; 
   d="scan'208";a="166165985"
From: Roland Dreier <rdreier@cisco.com>
To: "Zhao\, Yu" <yu.zhao@intel.com>
Cc: "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Alex Chiang <achiang@hp.com>, Matthew Wilcox <matthew@wil.cx>,
       Greg KH <greg@kroah.com>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization\@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 4/6 v3] PCI: support SR-IOV capability
References: <D8078B8B3B09934AA9F8F2D5FB3F28CE088751B5F4@pdsmsx502.ccr.corp.intel.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 30 Sep 2008 15:40:15 -0700
In-Reply-To: <D8078B8B3B09934AA9F8F2D5FB3F28CE088751B5F4@pdsmsx502.ccr.corp.intel.com>
	(Yu Zhao's message of "Sat, 27 Sep 2008 16:28:15 +0800")
Message-ID: <ada3ajhfeb4.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Sep 2008 22:40:16.0149 (UTC) FILETIME=[82408450:01C9234D]
Authentication-Results: sj-dkim-8; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim8002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > +       ctrl = pci_ari_enabled(dev) ? PCI_IOV_CTRL_ARI : 0;
 > +       pci_write_config_word(dev, pos + PCI_IOV_CTRL, ctrl);
 > +       ssleep(1);

You seem to sleep for 1 second wherever you write the IOV_CTRL
register.  Why is this?  Is this specified by PCI, or is it coming from
somewhere else?

 - R.
