Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbZIIUpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbZIIUpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 16:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbZIIUpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 16:45:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:39445 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbZIIUpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 16:45:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,360,1249282800"; 
   d="scan'208";a="447148678"
Date: Wed, 9 Sep 2009 13:45:06 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Greg KH <greg@kroah.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       Shane Huang <Shane.Huang@amd.com>, Chris Wright <chrisw@sous-sol.org>,
       Grant Grundler <grundler@parisc-linux.org>
Subject: Re: [PATCH 2/2] pci-stub: add pci_stub.ids parameter
Message-ID: <20090909134506.081e5983@jbarnes-g45>
In-Reply-To: <4A9F61CF.2090209@kernel.org>
References: <4A9F619C.2020705@kernel.org>
	<4A9F61CF.2090209@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Sep 2009 15:27:27 +0900
Tejun Heo <tj@kernel.org> wrote:

> Add ids module parameter which allows specifying initial IDs for the
> pci-stub driver.  When built into the kernel, pci-stub is linked
> before any real pci drivers and by setting up IDs from initialization
> it can prevent built-in drivers from attaching to specific devices.
> 
> While at it, make pci_stub_probe() print out about devices it grabbed
> to weed out "but my controller isn't being probed" bug reports.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
> Unchanged from the first posting.

Applied these two to linux-next, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
