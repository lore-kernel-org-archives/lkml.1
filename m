Return-Path: <linux-kernel-owner+w=401wt.eu-S1758312AbZBYBf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312AbZBYBf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 20:35:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755223AbZBYBfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 20:35:47 -0500
Received: from mga09.intel.com ([134.134.136.24]:13592 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754637AbZBYBfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 20:35:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,262,1233561600"; 
   d="scan'208";a="492831494"
Date: Wed, 25 Feb 2009 09:36:18 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v10 0/7] PCI: Linux kernel SR-IOV support
Message-ID: <20090225013618.GA12349@yzhao-otc.sh.intel.com>
References: <1235112888-9524-1-git-send-email-yu.zhao@intel.com> <49A3D04A.9010501@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A3D04A.9010501@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 24, 2009 at 06:47:38PM +0800, Avi Kivity wrote:
> Yu Zhao wrote:
> > Greetings,
> >
> > Following patches are intended to support SR-IOV capability in the
> > Linux kernel. With these patches, people can turn a PCI device with
> > the capability into multiple ones from software perspective, which
> > will benefit KVM and achieve other purposes such as QoS, security,
> > and etc.
> >   
> 
> Do those patches allow using a VF on the host (in other words, does the 
> kernel emulate config space accesses)?

Yes, if a VF's driver is loaded in the host, the VF works the same way
as normal PCI device.
