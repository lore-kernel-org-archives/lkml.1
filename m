Return-Path: <linux-kernel-owner+w=401wt.eu-S1753349Ab0AIXoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab0AIXoZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 18:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269Ab0AIXoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 18:44:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48476 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218Ab0AIXoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 18:44:24 -0500
Date: Sat, 9 Jan 2010 15:43:05 -0800
From: Greg KH <gregkh@suse.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
       devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>, cocci@diku.dk
Subject: Re: [PATCH 1/3] staging: make PCI device id constant
Message-ID: <20100109234304.GA6168@suse.de>
References: <4B490EC2.7050703@freemail.hu>
 <20100109154115.152c55e1@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100109154115.152c55e1@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 09, 2010 at 03:41:15PM -0800, Arjan van de Ven wrote:
> On Sun, 10 Jan 2010 00:18:26 +0100
> Németh Márton <nm127@freemail.hu> wrote:
> 
> > From: Márton Németh <nm127@freemail.hu>
> > 
> > The id_table field of the struct pci_driver is constant in
> > <linux/pci.h> so it is worth to make the initialization data also
> > constant.
> 
> 
> the PCI ID table can get written too via sysfs... making it const
> breaks that...

It shouldn't, I thought that was what we used the dynids field in the
pci_driver structure :)

thanks,

greg k-h
