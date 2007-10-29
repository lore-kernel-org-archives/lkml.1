Return-Path: <linux-kernel-owner+w=401wt.eu-S1751589AbXJ2WSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589AbXJ2WSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 18:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbXJ2WRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 18:17:52 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60484 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183AbXJ2WRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 18:17:51 -0400
Date: Mon, 29 Oct 2007 15:13:39 -0700
From: Greg KH <greg@kroah.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, kkeil@suse.de
Subject: Re: [RFC / git patch] Move pci_find_* under CONFIG_PCI_LEGACY
Message-ID: <20071029221339.GA12058@kroah.com>
References: <20071029185047.GA4951@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029185047.GA4951@havoc.gtf.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 02:50:48PM -0400, Jeff Garzik wrote:
> I am actively working on killing the remaining users of
> pci_find_device().  The results can be found in the 'isdn-pci' and
> 'warnings' branches of jgarzik/misc-2.6.git.  Time consuming work
> converting ancient drivers to PCI hotplug API, but it's almost done.
> 
> HOWEVER, given the limited number of drivers that are turned off when
> that API is disabled, I felt it would be nice to provide the option
> of eliminating the pci_find_* warnings that emit on every build (due
> to presence in drivers/pci/search.c).
> 
> Please consider pulling from 'pci-legacy' branch of
> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git pci-legacy

Looks great to me, I'll pull this tomorrow when I get back to my
development boxes...

thanks,

greg k-h
