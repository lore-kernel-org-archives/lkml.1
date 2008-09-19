Return-Path: <linux-kernel-owner+w=401wt.eu-S1754482AbYISVqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbYISVqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 17:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbYISVqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 17:46:24 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:58338 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbYISVqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 17:46:23 -0400
Date: Fri, 19 Sep 2008 13:34:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org, dwmw2@infradead.org
Subject: Re: linux-next: Tree for September 19 (kvm + intel_iommu)
Message-Id: <20080919133451.ffcb1075.randy.dunlap@oracle.com>
In-Reply-To: <20080919143820.51d1a5d9.sfr@canb.auug.org.au>
References: <20080919143820.51d1a5d9.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2008 14:38:20 +1000 Stephen Rothwell wrote:


kvm calls intel_iommu_found(), which won't exist if CONFIG_DMAR=n:

arch/x86/kvm/built-in.o: In function `kvm_dev_ioctl_check_extension':
(.text+0x5588): undefined reference to `intel_iommu_found'
make[1]: *** [.tmp_vmlinux1] Error 1


---
~Randy
