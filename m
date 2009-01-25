Return-Path: <linux-kernel-owner+w=401wt.eu-S1752904AbZAYFgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbZAYFgQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 00:36:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750931AbZAYFf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 00:35:59 -0500
Received: from colo.lackof.org ([198.49.126.79]:47341 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbZAYFf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 00:35:59 -0500
Date: Sat, 24 Jan 2009 22:35:45 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: Re: [PATCH 1/2] PCI/MSI: Introduce pci_msix_table_size()
Message-ID: <20090125053545.GC22539@colo.lackof.org>
References: <200901240019.36794.rjw@sisk.pl> <200901240021.14940.rjw@sisk.pl> <20090125052947.GB22539@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090125052947.GB22539@colo.lackof.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 24, 2009 at 10:29:47PM -0700, Grant Grundler wrote:
> Is this intended to be used by drivers?

The answer depends on if "PCI Express port driver" can be loaded
as a module.

> If so, can you please add (a) corresponding documentation in
> either the MSI or pci.txt files and (b) EXPORT_SYMBOL_GPL?
> 
> If not, can this declaration be static?
> (I haven't yet looked at the second patch...maybe this is obvious once
> I do.)

The answer seems to be no, it can't be static.

thanks,
grant
