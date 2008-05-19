Return-Path: <linux-kernel-owner+w=401wt.eu-S1757971AbYESPVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971AbYESPVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbYESPVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:21:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47244 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbYESPVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:21:08 -0400
Date: Mon, 19 May 2008 08:20:21 -0700
From: Greg KH <greg@kroah.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: Oliver Neukum <oliver@neukum.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug #10630] USB devices plugged into dock are not discoverred
	until reload of ehci-hcd
Message-ID: <20080519152021.GA7620@kroah.com>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik> <200805191002.43734.oliver@neukum.org> <20080519105150.GB4557@ics.muni.cz> <200805191239.14431.oliver@neukum.org> <20080519104626.GD4700@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080519104626.GD4700@ics.muni.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 12:46:26PM +0200, Lukas Hejtmanek wrote:
> On Mon, May 19, 2008 at 12:39:13PM +0200, Oliver Neukum wrote:
> > > ls -F /sys/module/ehci_hcd/
> > > drivers/  holders/  initstate  notes/  parameters/  refcnt  sections/
> > 
> > Sorry, I was refering to the registers file as documented in
> > Documentation/usb/ehci.txt
> 
> I've checked that but still have no idea how to obtain the registers.

mount -t debugfs /sys/kernel/debug
cd /sys/debug/ehci/
cd <DEVICE PCI ID>
cat registers > file_to_emai_to_oliver.txt


Hope this helps,

greg k-h
