Return-Path: <linux-kernel-owner+w=401wt.eu-S1756972AbZHZGy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972AbZHZGy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756845AbZHZGy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:54:26 -0400
Received: from kroah.org ([198.145.64.141]:55732 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756769AbZHZGyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:54:25 -0400
Date: Tue, 25 Aug 2009 23:45:45 -0700
From: Greg KH <greg@kroah.com>
To: Mike Mohr <akihana@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: expresscard hotplug not working
Message-ID: <20090826064545.GA7023@kroah.com>
References: <4746469c0908251817u225609bax66ea27261a1ef038@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4746469c0908251817u225609bax66ea27261a1ef038@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 06:17:28PM -0700, Mike Mohr wrote:
> Hi,
> 
> I think I'm having a similar problem to the fellow listed here:
> 
> http://kerneltrap.org/mailarchive/linux-kernel/2007/10/16/344543
> 
> The only difference is that no card will work at all unless it is
> inserted before system power is turned on.  If the card is removed
> while the system is running it stops working and will never return to
> life unless the system is rebooted with the card in the slot.
> 
> My kernel is configured exactly as this page describes:
> 
> http://www.gentoo-wiki.info/ExpressCard
> 
> However, I do not receive anything in dmesg except the reports of the
> driver being unloaded and/or loaded.  Attempts to insert the card
> after the machine is up elicit no kernel messages.  I'm thinking there
> may be a missing PCI ID somewhere in the pciehp/pci_hotplug driver(s),
> but I could well be mistaken.

Do you have the acpiphp or pciehp driver loaded before trying to insert
your card?

thanks,

greg k-h
