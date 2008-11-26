Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbYKZPAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbYKZPAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 10:00:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbYKZO7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 09:59:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:3864 "EHLO mga02.intel.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751676AbYKZO7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 09:59:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,669,1220252400"; 
   d="scan'208";a="467569756"
Date: Wed, 26 Nov 2008 22:03:03 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Cc: "greg@kroah.com" <greg@kroah.com>, "matthew@wil.cx" <matthew@wil.cx>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       xen-devel@lists.xensource.com,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: [SR-IOV driver example 0/3] introduction
Message-ID: <20081126140303.GA13641@yzhao12-linux.sh.intel.com>
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121183605.GA7810@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SR-IOV drivers of Intel 82576 NIC are available. There are two parts
of the drivers: Physical Function driver and Virtual Function driver.
The PF driver is based on the IGB driver and is used to control PF to
allocate hardware specific resources and interface with the SR-IOV core.
The VF driver is a new NIC driver that is same as the traditional PCI
device driver. It works in both the host and the guest (Xen and KVM)
environment.

These two drivers are testing versions and they are *only* intended to
show how to use SR-IOV API.

Intel 82576 NIC specification can be found at:
http://download.intel.com/design/network/datashts/82576_Datasheet_v2p1.pdf

[SR-IOV driver example 1/3] PF driver: allocate hardware specific resource
[SR-IOV driver example 2/3] PF driver: integrate with SR-IOV core
[SR-IOV driver example 3/3] VF driver tar ball
