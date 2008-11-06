Return-Path: <linux-kernel-owner+w=401wt.eu-S1755864AbYKFEud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864AbYKFEud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 23:50:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbYKFEuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 23:50:24 -0500
Received: from kroah.org ([198.145.64.141]:38260 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753060AbYKFEuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 23:50:23 -0500
Date: Wed, 5 Nov 2008 20:48:28 -0800
From: Greg KH <greg@kroah.com>
To: Yu Zhao <yu.zhao@intel.com>
Cc: linux-pci@vger.kernel.org, achiang@hp.com, grundler@parisc-linux.org,
       mingo@elte.hu, jbarnes@virtuousgeek.org, matthew@wil.cx,
       randy.dunlap@oracle.com, rdreier@cisco.com,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
Message-ID: <20081106044828.GA30417@kroah.com>
References: <20081022083809.GA3757@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022083809.GA3757@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 04:38:09PM +0800, Yu Zhao wrote:
> Greetings,
> 
> Following patches are intended to support SR-IOV capability in the
> Linux kernel. With these patches, people can turn a PCI device with
> the capability into multiple ones from software perspective, which
> will benefit KVM and achieve other purposes such as QoS, security,
> and etc.

Is there any actual users of this API around yet?  How was it tested as
there is no hardware to test on?  Which drivers are going to have to be
rewritten to take advantage of this new interface?

thanks,

greg k-h
