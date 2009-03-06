Return-Path: <linux-kernel-owner+w=401wt.eu-S1755879AbZCFUJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbZCFUJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 15:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbZCFUJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 15:09:44 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:49613 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561AbZCFUJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 15:09:43 -0500
Date: Fri, 6 Mar 2009 13:09:42 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Yu Zhao <yu.zhao@intel.com>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 2/7] PCI: restore saved SR-IOV state
Message-ID: <20090306200941.GE25995@parisc-linux.org>
References: <1235112888-9524-1-git-send-email-yu.zhao@intel.com> <1235112888-9524-3-git-send-email-yu.zhao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235112888-9524-3-git-send-email-yu.zhao@intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 02:54:43PM +0800, Yu Zhao wrote:
> Signed-off-by: Yu Zhao <yu.zhao@intel.com>

It needs a changelog ...

> +static void sriov_restore_state(struct pci_dev *dev)
> +{
[...]
> +}
> +
[...]
> +/**
> + * pci_restore_iov_state - restore the state of the IOV capability
> + * @dev: the PCI device
> + */
> +void pci_restore_iov_state(struct pci_dev *dev)
> +{
> +	if (dev->sriov)
> +		sriov_restore_state(dev);
> +}

Apart from the design pattern I mentioned in my previous email also
appearing here, I see no problems with this patch.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
