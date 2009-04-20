Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbZDTLIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbZDTLIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 07:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbZDTLII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 07:08:08 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:41223 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbZDTLIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 07:08:05 -0400
Date: Mon, 20 Apr 2009 05:08:04 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 2/2] pci, msi: Define PCI_MSI_MASK_32/64
Message-ID: <20090420110803.GS1926@parisc-linux.org>
References: <49EBD5F3.9090107@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EBD5F3.9090107@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 10:54:59AM +0900, Hidetoshi Seto wrote:
> Impact: cleanup, improve readability
> 
> Define PCI_MSI_MASK_32/64 for 32/64bit devices, instead of using
> implicit offset (-4), "PCI_MSI_MASK_BIT - 4" and "PCI_MSI_MASK_BIT".
> 
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>

Yes, nice cleanup.

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
