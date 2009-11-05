Return-Path: <linux-kernel-owner+w=401wt.eu-S1758698AbZKETHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698AbZKETHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 14:07:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758139AbZKETHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 14:07:05 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:47128 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758057AbZKETHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 14:07:04 -0500
Date: Thu, 5 Nov 2009 12:07:07 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, rdh@east.sun.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci/pcie: Avoid unnecessary PCIe link retrains
Message-ID: <20091105190707.GM10555@parisc-linux.org>
References: <19184.41676.262206.134000@gargle.gargle.HOWL> <200911041628.17905.bjorn.helgaas@hp.com> <4AF240E7.8050200@jp.fujitsu.com> <200911051159.26046.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911051159.26046.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 05, 2009 at 12:59:25PM -0600, Bjorn Helgaas wrote:
> Here's another possibility, the idea being to collect all the PCIe
> stuff in one place.  This would require a lot of changes in the PCIe
> driver code, but most of them would be trivial.

I don't like the idea of kmallocing a 6- or 10-byte data structure
... better to keep it in the pci_dev.  Maybe embedding a pcie_dev inside
the pci_dev would be a good idea, but unless there're more things to
move to it, this seems like a net loss to me.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
