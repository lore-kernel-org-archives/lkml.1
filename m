Return-Path: <linux-kernel-owner+w=401wt.eu-S935185AbYBNXtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935185AbYBNXtd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 18:49:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764977AbYBNXse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 18:48:34 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33339 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934642AbYBNXsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 18:48:32 -0500
Date: Thu, 14 Feb 2008 15:52:21 -0800
From: Greg KH <greg@kroah.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de
Subject: Re: [PATCH 00/14] [ISDN] HiSax hotplug conversion
Message-ID: <20080214235221.GA6399@kroah.com>
References: <74fc75b3eadfa82aee70b855e9944b5439a259d5.1203031878.git.jeff@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74fc75b3eadfa82aee70b855e9944b5439a259d5.1203031878.git.jeff@garzik.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 11:04:04PM -0400, Jeff Garzik wrote:
> 
> This is a refresh of an on-going work-in-progress:  convert the last
> remaining users of pci_find_device() to the ISA/PCI/etc.  hotplug APIs
> now in standard use.  After SCSI's gdth, ISDN's HiSax suite of drivers
> are just about the last place using the older API.

Yeah!

I have some patches in my pci tree to get rid of some pci_find_slot()
usages, as well, so we are almost rid of these old functions.

Thanks a lot for doing this work, I really appreciate it.

greg k-h
