Return-Path: <linux-kernel-owner+w=401wt.eu-S1758798AbZKEU3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798AbZKEU3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 15:29:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758611AbZKEU3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 15:29:39 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:30967 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758592AbZKEU3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 15:29:39 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] pci/pcie: Avoid unnecessary PCIe link retrains
Date: Thu, 5 Nov 2009 14:29:40 -0600
User-Agent: KMail/1.9.10
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, rdh@east.sun.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
References: <19184.41676.262206.134000@gargle.gargle.HOWL> <200911051159.26046.bjorn.helgaas@hp.com> <20091105190707.GM10555@parisc-linux.org>
In-Reply-To: <20091105190707.GM10555@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911051329.41893.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 November 2009 12:07:07 pm Matthew Wilcox wrote:
> On Thu, Nov 05, 2009 at 12:59:25PM -0600, Bjorn Helgaas wrote:
> > Here's another possibility, the idea being to collect all the PCIe
> > stuff in one place.  This would require a lot of changes in the PCIe
> > driver code, but most of them would be trivial.
> 
> I don't like the idea of kmallocing a 6- or 10-byte data structure
> ... better to keep it in the pci_dev.  Maybe embedding a pcie_dev inside
> the pci_dev would be a good idea, but unless there're more things to
> move to it, this seems like a net loss to me.

That's true, it's not worth it for such a small structure.  I figured
there would probably be more PCIe-related stuff that could go there,
e.g., embedding the link_state directly.  But I haven't looked to
see whether there actually is enough PCIe stuff to make it worthwhile.

Bjorn

