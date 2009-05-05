Return-Path: <linux-kernel-owner+w=401wt.eu-S1758720AbZEESh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720AbZEESh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 14:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756897AbZEEShs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 14:37:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:53323 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754321AbZEEShr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 14:37:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,298,1239001200"; 
   d="scan'208";a="687722166"
Date: Tue, 5 May 2009 11:37:39 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 1/2] pci, msi: Remove unused/obsolete macros and
 definitions
Message-ID: <20090505113739.08d36a89@hobbes>
In-Reply-To: <49EBD5EC.4040905@jp.fujitsu.com>
References: <49EBD5EC.4040905@jp.fujitsu.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Apr 2009 10:54:52 +0900
Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:

> Impact: cleanup, spec compliance
> 
> This patch does:
> 
>  - Remove unused msi/msix_enable/disable macros.
>    User should use msi/msix_set_enable() functions instead.
> 
>  - Remove unused msix_mask/unmask/pending macros.
>    These macros are useless because they are not based on any of
>    the PCI Local Bus Specifications properly.
>    It seems that they were written based on a draft of PCI spec,
>    and that the draft was the MSI-X ECN that underwent membership
>    review in September 2002.
>    (* In the draft, the size of a entry in MSI-X table was 64bit,
>       containing 32bit message data and DWORD aligned lower address
>       plus a pending bit and a mask bit.(30+1+1bit)  The higher
>       address was placed in MSI-X capability structure and shared
>       by all entries.)
> 
>  - Remove PCI_MSIX_FLAGS_BITMASK.
>    This definition also come from the draft ECN.
> 
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>

Applied to my linux-next branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
