Return-Path: <linux-kernel-owner+w=401wt.eu-S1760270AbYGRRL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760270AbYGRRL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 13:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760918AbYGRRKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 13:10:00 -0400
Received: from ryu.zarb.org ([212.85.153.228]:38435 "EHLO ryu.zarb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760480AbYGRRJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 13:09:53 -0400
Subject: Re: 2.6.26 fails to boot on Acer TravelMate 5520 due to PCIE ASPM
From: Pascal Terjan <pterjan@mandriva.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@vger.kernel.org>
In-Reply-To: <1216344100.6105.1.camel@sli10-desk.sh.intel.com>
References: <1216286420.26653.12.camel@plop>
	 <1216344100.6105.1.camel@sli10-desk.sh.intel.com>
Content-Type: text/plain
Organization: Mandriva
Date: Fri, 18 Jul 2008 19:09:47 +0200
Message-Id: <1216400987.21525.9.camel@plop>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.4-1mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-18 at 09:21 +0800, Shaohua Li wrote:
> On Thu, 2008-07-17 at 11:20 +0200, Pascal Terjan wrote:
> > When CONFIG_PCIEASPM is activated, Acer TravelMate 5520 will hang at
> > "Setting up standard PCI resources"
> > 
> > pcie_noaspm does not seem to help
> Can you double check it? With pcie_noaspm, the aspm driver does nothing.
> 

Indeed, the option actually works fine and allows the machine to boot my
small test kernel with CONFIG_PCIEASPM.

I had tried the option on another 2.6.26 vanilla kernel (with a totally
different config) and that one hangs at the same point without ASPM so
I'm currently doing some more investigation


