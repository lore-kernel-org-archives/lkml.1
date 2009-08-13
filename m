Return-Path: <linux-kernel-owner+w=401wt.eu-S1752700AbZHMVrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbZHMVrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 17:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbZHMVrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 17:47:31 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53937 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbZHMVra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 17:47:30 -0400
Date: Thu, 13 Aug 2009 22:47:29 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       linux-pci@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [RFC] usb: Add support for runtime power management of the hcd
Message-ID: <20090813214729.GD14532@srcf.ucam.org>
References: <20090813003544.GB2532@srcf.ucam.org> <Pine.LNX.4.44L0.0908131117130.2940-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0908131117130.2940-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 11:22:44AM -0400, Alan Stern wrote:

> You have to call the HCD's pci_suspend method!  Not to mention calling 
> synchronize_irq and all the other stuff in hcd_pci_suspend and 
> hcd_pci_suspend_noirq.

The bus level code does this, assuming that the driver-level code 
doesn't return an error.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
