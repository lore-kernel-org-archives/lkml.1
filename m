Return-Path: <linux-kernel-owner+w=401wt.eu-S1757023AbYJHCuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023AbYJHCuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 22:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbYJHCuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 22:50:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:55737 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbYJHCuB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 22:50:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,376,1220252400"; 
   d="scan'208";a="345228908"
From: "Zhao, Yu" <yu.zhao@intel.com>
To: Roland Dreier <rdreier@cisco.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Alex Chiang <achiang@hp.com>, Matthew Wilcox <matthew@wil.cx>,
       Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Date: Wed, 8 Oct 2008 10:49:27 +0800
Subject: RE: [PATCH 4/6 v3] PCI: support SR-IOV capability
Thread-Topic: [PATCH 4/6 v3] PCI: support SR-IOV capability
Thread-Index: AckjTY+8NtGVdgD+R8ugm8p+/v8cqwFopo6g
Message-ID: <D8078B8B3B09934AA9F8F2D5FB3F28CE08A3D24396@pdsmsx502.ccr.corp.intel.com>
References: <D8078B8B3B09934AA9F8F2D5FB3F28CE088751B5F4@pdsmsx502.ccr.corp.intel.com>
 <ada3ajhfeb4.fsf@cisco.com>
In-Reply-To: <ada3ajhfeb4.fsf@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 01, 2008 6:40 AM, Roland Dreier wrote:
> > +       ctrl = pci_ari_enabled(dev) ? PCI_IOV_CTRL_ARI : 0;
> > +       pci_write_config_word(dev, pos + PCI_IOV_CTRL, ctrl);
> > +       ssleep(1);
>
>You seem to sleep for 1 second wherever you write the IOV_CTRL
>register.  Why is this?  Is this specified by PCI, or is it coming from
>somewhere else?

This is specified by on pp. 39 PCI SR-IOV specification 1.0. You can find it at: http://www.pcisig.com/members/downloads/specifications/iov/sr-iov1.0_11Sep07.pdf

Thanks.

>
> - R.
