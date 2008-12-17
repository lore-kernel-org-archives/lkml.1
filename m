Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753369AbYLQOQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbYLQOQU (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 09:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbYLQOQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 09:16:04 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:54134 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbYLQOQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 09:16:03 -0500
Date: Wed, 17 Dec 2008 07:15:43 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Yu Zhao <yu.zhao@intel.com>, linux-pci@vger.kernel.org, achiang@hp.com,
        bjorn.helgaas@hp.com, grundler@parisc-linux.org, greg@kroah.com,
        mingo@elte.hu, randy.dunlap@oracle.com, rdreier@cisco.com,
        horms@verge.net.au, yinghai@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 0/13 v7] PCI: Linux kernel SR-IOV support
Message-ID: <20081217141542.GB19967@parisc-linux.org>
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com> <200812161523.55238.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812161523.55238.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 03:23:53PM -0800, Jesse Barnes wrote:
> I applied 1-9 to my linux-next branch; and at least patch #10 needs a respin, 

I still object to #2.  We should have the flexibility to have 'struct
resource's that are not in this array in the pci_dev.  I would like to
see the SR-IOV resources _not_ in this array (and indeed, I'd like to
see PCI bridges keep their producer resources somewhere other than in
this array).  I accept that there are still some problems with this, but
patch #2 moves us further from being able to achieve this goal, not
closer.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
