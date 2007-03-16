Return-Path: <linux-kernel-owner+w=401wt.eu-S965824AbXCPSmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965824AbXCPSmz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 14:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbXCPSmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 14:42:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:38023 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753596AbXCPSmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 14:42:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,293,1170662400"; 
   d="scan'208"; a="213941351:sNHT233073183"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH 2.6.18] PCI: Turn pci_fixup_video into generic for embedded VGA
Date: Fri, 16 Mar 2007 11:42:39 -0700
User-Agent: KMail/1.9.6
Cc: eiichiro.oiwa.nm@hitachi.com, akpm@osdl.org, tony.luck@intel.com,
       greg@kroah.com, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
References: <XNM1$9$0$4$$3$3$7$A$9002686U451b55cd@hitachi.com> <200609280936.02098.jesse.barnes@intel.com> <200703161120.46123.bjorn.helgaas@hp.com>
In-Reply-To: <200703161120.46123.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703161142.39854.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 16, 2007 10:20 am Bjorn Helgaas wrote:
> Are there really ia64 machines where we need to use the option ROM
> copy at 0xC0000?  If so, is this documented somewhere?  I couldn't
> find any mention in DIG64, EFI, or internal HP architecture specs.
>
> If we do need to use it, ia64 has a bit of a problem because on some
> boxes, the 0xC0000 memory supports only cacheable access, the VGA
> frame buffer at 0xA0000 supports only uncacheable access, and the
> usual ia64 ioremap mapping is a 16MB page that covers both.

Apparently Eichiro's machine needs it, and of course there are i386 and 
x86_64 machines that need it to, so it makes sense that it be generic.

Jesse
