Return-Path: <linux-kernel-owner+w=401wt.eu-S1761118AbZJIRsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761118AbZJIRsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 13:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758720AbZJIRsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 13:48:39 -0400
Received: from complete.lackof.org ([198.49.126.79]:53961 "EHLO
	complete.lackof.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbZJIRsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 13:48:39 -0400
Date: Fri, 9 Oct 2009 11:48:02 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: mankan srinivas <s_mankan@hotmail.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Sample PCI Linux Device Driver
Message-ID: <20091009174802.GA10309@lackof.org>
References: <BAY108-F18507D362F5105C57CCC2FE59E0@phx.gbl> <20070214064427.GA15497@kroah.com> <BAY138-W981A223FAD78C301641E6E5CC0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAY138-W981A223FAD78C301641E6E5CC0@phx.gbl>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 08, 2009 at 06:58:01PM +0000, mankan srinivas wrote:
> I am working on developing PCI based Linux Device Driver. Could you
> please send me few sample code. I am looking for the code which has more
> information about low-level driver code talks to the hardware. Any real
> example code is greatly appreciated.

Please start by reading Documentation/PCI/pci.txt and MSI-HOWTO.txt
Lots more useful info in Documentation/ that should help you out
(e.g. suspend/resume, hotplug, DMA API, etc)

Here are some specific driver examples:
    drivers/net/forcedeth.c
    drivers/net/e1000e/
    drivers/scsi/mpt2sas/
    drivers/ata/sata_sil24.c
    drivers/ata/sata_mv.c

hth,
grant
