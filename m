Return-Path: <linux-kernel-owner+w=401wt.eu-S1756492AbZCFVQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbZCFVQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 16:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754457AbZCFVQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 16:16:17 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:52356 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbZCFVQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 16:16:17 -0500
Date: Fri, 6 Mar 2009 14:16:15 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Yu Zhao <yu.zhao@intel.com>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH v10 6/7] PCI: document SR-IOV sysfs entries
Message-ID: <20090306211614.GI25995@parisc-linux.org>
References: <1235112888-9524-1-git-send-email-yu.zhao@intel.com> <1235112888-9524-7-git-send-email-yu.zhao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235112888-9524-7-git-send-email-yu.zhao@intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Randy, can you wordsmith this one?

I think I'm starting to understand the difference between physfn and
dep_link, but an example would definitely help.  It may or may not be
appropriate to put it in.

On Fri, Feb 20, 2009 at 02:54:47PM +0800, Yu Zhao wrote:
> Signed-off-by: Yu Zhao <yu.zhao@intel.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-pci |   27 +++++++++++++++++++++++++++
>  1 files changed, 27 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
> index ceddcff..84dc100 100644
> --- a/Documentation/ABI/testing/sysfs-bus-pci
> +++ b/Documentation/ABI/testing/sysfs-bus-pci
> @@ -9,3 +9,30 @@ Description:
>  		that some devices may have malformatted data.  If the
>  		underlying VPD has a writable section then the
>  		corresponding section of this file will be writable.
> +
> +What:		/sys/bus/pci/devices/.../virtfn/N
> +Date:		February 2009
> +Contact:	Yu Zhao <yu.zhao@intel.com>
> +Description:
> +		This symbol link appears when hardware supports SR-IOV
> +		capability and Physical Function driver has enabled it.
> +		The symbol link points to the PCI device sysfs entry of
> +		Virtual Function whose index is N (0...MaxVFs-1).
> +
> +What:		/sys/bus/pci/devices/.../virtfn/dep_link
> +Date:		February 2009
> +Contact:	Yu Zhao <yu.zhao@intel.com>
> +Description:
> +		This symbol link appears when hardware supports SR-IOV
> +		capability and Physical Function driver has enabled it,
> +		and this device has vendor specific dependencies with
> +		others. The symbol link points to the PCI device sysfs
> +		entry of Physical Function this device depends on.
> +
> +What:		/sys/bus/pci/devices/.../physfn
> +Date:		February 2009
> +Contact:	Yu Zhao <yu.zhao@intel.com>
> +Description:
> +		This symbol link appears when a device is Virtual Function.
> +		The symbol link points to the PCI device sysfs entry of
> +		Physical Function this device associates with.
> -- 
> 1.6.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
