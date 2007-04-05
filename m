Return-Path: <linux-kernel-owner+w=401wt.eu-S965158AbXDEJ0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965158AbXDEJ0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 05:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965254AbXDEJ0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 05:26:52 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:43581 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965158AbXDEJ0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 05:26:50 -0400
Date: Thu, 5 Apr 2007 10:26:38 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: David Brownell <david-b@pacbell.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linux ACPI list <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070405092638.GA30208@srcf.ucam.org>
References: <200704031741.42273.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704031741.42273.david-b@pacbell.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [patch 2.6.21-rc5-git] make /proc/acpi/wakeup more useful
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 05:41:42PM -0700, David Brownell wrote:
> This updates /proc/acpi/wakeup to be more informative, primarily by showing
> the sysfs node associated with each wakeup-enabled device.  Example:

This looks good. 

> 	S139	  S4	 disabled  

Any idea what this one is? There's the potential for all sorts of weird 
platform devices to expose wakeup capabilities.

> Eventually this file should be removed, but until then it's almost the only
> way we have to tell how the relevant ACPI tables are broken (and cope).  In
> that example, two devices don't actually exist (USB3, S139), one can't issue
> wakeup events (PCI0), and two seem harmlessly (?) confused (MDM and AUD are
> the same PCI device, but it's the _modem_ that does wake-on-ring).  

Could the MDM entry be referring to the modem codec on the ac97 or 
hda bus? 

-- 
Matthew Garrett | mjg59@srcf.ucam.org
