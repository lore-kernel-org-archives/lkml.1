Return-Path: <linux-kernel-owner+w=401wt.eu-S1755714AbZDGOdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714AbZDGOdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 10:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbZDGOdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 10:33:06 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:47104 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbZDGOdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 10:33:05 -0400
Date: Tue, 7 Apr 2009 08:32:49 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       andrew.patterson@hp.com, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH next] pci: fix build error with !PCIE_ECRC
Message-ID: <20090407143248.GA21727@parisc-linux.org>
References: <20090407123707.GA18687@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090407123707.GA18687@orion>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 04:37:08PM +0400, Alexander Beregalov wrote:
> Fix this build error:
> drivers/built-in.o: In function `pci_init_capabilities':
> drivers/pci/probe.c:989: undefined reference to `pcie_set_ecrc_checking'
> drivers/built-in.o: In function `pci_setup':
> drivers/pci/pci.c:2547: undefined reference to `pcie_ecrc_get_policy'

>  config PCIE_ECRC
>  	bool "PCI Express ECRC support"
> -	depends on PCI
> +	depends on PCI && PCIEPORTBUS

How does this part of the patch relate to the above description?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
