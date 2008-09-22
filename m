Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbYIVTx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbYIVTx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 15:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbYIVTxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 15:53:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751619AbYIVTxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 15:53:50 -0400
Date: Mon, 22 Sep 2008 12:52:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org, avi@qumranet.com,
       kvm@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: mmotm 2008-09-22-01-36 uploaded (kvm)
Message-Id: <20080922125227.2b837457.akpm@linux-foundation.org>
In-Reply-To: <20080922111947.507e34b1.randy.dunlap@oracle.com>
References: <200809220838.m8M8cwC2031790@imap1.linux-foundation.org>
	<20080922111947.507e34b1.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2008 11:19:47 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Mon, 22 Sep 2008 01:38:58 -0700 akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2008-09-22-01-36 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > It contains the following patches against 2.6.27-rc7:
> 
> 
> 
> ERROR: "intel_iommu_found" [arch/x86/kvm/kvm.ko] undefined!
> 
> when CONFIG_DMAR=n.
> 

Yes, I got that too.  i386 allmodconfig fails similarly.  It's still
unclear which tree in linux-next broke it.  PCI or async_tx, perhaps.
