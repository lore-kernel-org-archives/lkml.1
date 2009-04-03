Return-Path: <linux-kernel-owner+w=401wt.eu-S1758906AbZDCBlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906AbZDCBlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 21:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbZDCBlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 21:41:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:21504 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbZDCBlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 21:41:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,316,1235980800"; 
   d="scan'208";a="127339491"
Subject: paravirtops kernel and HVM guests
From: Nitin A Kamble <nitin.a.kamble@intel.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <49C18487.1020703@goop.org>
References: <49C148AF.5050601@goop.org> <49C16411.2040705@redhat.com>
	 <49C1665A.4080707@goop.org> <49C16A48.4090303@redhat.com>
	 <49C17230.20109@goop.org> <49C17880.7080109@redhat.com>
	 <49C17BD8.6050609@goop.org> <49C17E22.9040807@redhat.com>
	 <49C18487.1020703@goop.org>
Content-Type: text/plain
Date: Thu, 02 Apr 2009 18:41:41 -0800
Message-Id: <1238726501.6208.6.camel@mukti.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy,
  I was trying the latest bits from your paravirtops tree with
xen-unstable. Dom0 is booting fine in Fedora 10 environment. I am seeing
page fault handing error while trying to create an HVM guest. 
Is anybody working on the HVM support on top of paravirtops kernel?

privcmd_fault: vma=ffff880068081210 7f7cb7cfe000-7f7cb7dfe000, pgoff=0,
uv=00007f7cb7cfe000, ptep=(null) 0000000000000000
Pid: 4253, comm: qemu-dm Not tainted 2.6.29-rc8-tip #6
Call Trace:
 [<ffffffff814357bf>] privcmd_fault+0x59/0x67
 [<ffffffff810d34ce>] __do_fault+0x50/0x349
 [<ffffffff8102912d>] ? __raw_callee_save_xen_pud_val+0x11/0x1e
 [<ffffffff810d5659>] handle_mm_fault+0x2e2/0x6e9
 [<ffffffff8102b9c2>] ? check_events+0x12/0x20
 [<ffffffff8102b9af>] ? xen_restore_fl_direct_end+0x0/0x1
 [<ffffffff816ba9ba>] ? _spin_unlock_irqrestore+0x38/0x3d
 [<ffffffff816bcee9>] do_page_fault+0x2a5/0x2bc
 [<ffffffff816bad45>] page_fault+0x25/0x30

Thanks & Regards,
Nitin

