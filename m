Return-Path: <linux-kernel-owner+w=401wt.eu-S1752318AbZHOU6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbZHOU6Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 16:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbZHOU6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 16:58:23 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42953 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbZHOU6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 16:58:22 -0400
Date: Sat, 15 Aug 2009 21:58:17 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       linux-pci@vger.kernel.org, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [RFC] PCI: Runtime power management
Message-ID: <20090815205817.GA30254@srcf.ucam.org>
References: <Pine.LNX.4.44L0.0908151143560.18415-100000@netrider.rowland.org> <200908152254.23227.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908152254.23227.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 15, 2009 at 10:54:23PM +0200, Rafael J. Wysocki wrote:

> runtime_wakeup - if set, the device is allowed to do remote wakeup at run time
>   That could be represented as 'runtime_wakeup' under 'power' with the
>   following values:
>   * no value (empty file) is 'runtime' is 'disabled'
>   * 'enabled'
>   * 'disabled'
>   To set/unset the user space writes 'enabled'/'disabled' to it, respectively.
>   The default is set.

Why would you ever want runtime_wakeup to be false unless 
runtime_forbidden is true? Surely the point of runtime power management 
is to be transparent to the user, in which case remote wakeup is 
required?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
