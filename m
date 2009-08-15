Return-Path: <linux-kernel-owner+w=401wt.eu-S1752009AbZHOV16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbZHOV16 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 17:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbZHOV16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 17:27:58 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:55843 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbZHOV15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 17:27:57 -0400
Date: Sat, 15 Aug 2009 22:27:56 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       linux-pci@vger.kernel.org, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [RFC] PCI: Runtime power management
Message-ID: <20090815212756.GA31784@srcf.ucam.org>
References: <Pine.LNX.4.44L0.0908151143560.18415-100000@netrider.rowland.org> <200908152254.23227.rjw@sisk.pl> <20090815205817.GA30254@srcf.ucam.org> <200908152321.53283.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908152321.53283.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 15, 2009 at 11:21:53PM +0200, Rafael J. Wysocki wrote:

> I can even imagine a scenario where this setting might be useful, like when
> we don't want a network adapter to be woken up from the outside.

I think in that case we'd probably just want the interface to be downed? 
Some of this is going to require device-specific policy, I think - for 
the network case we probably want something in between IF_RUNNING and 
IF_DOWN (IF_CARRIER, perhaps) that indicates that we want the PHY to be 
powered. Pushing this out to sysfs would mean we'd have a consistent 
interface but varying semantics, and I'm not convinced that's an 
especially helpful interface.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
