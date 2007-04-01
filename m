Return-Path: <linux-kernel-owner+w=401wt.eu-S933089AbXDAOxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089AbXDAOxf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933140AbXDAOxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:53:34 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:57213 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933089AbXDAOxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:53:33 -0400
Date: Sun, 1 Apr 2007 15:53:18 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Alexey Starikovskiy <aystarik@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Message-ID: <20070401145317.GA17776@srcf.ucam.org>
References: <460E0158.7090705@goop.org> <8f8ff01d0703310033y74421cfcl747ece1be003471@mail.gmail.com> <460F511E.2090102@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <460F511E.2090102@goop.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: 2.6.21-rc5: Thinkpad X60 gets critical thermal shutdowns
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2007 at 11:28:46PM -0700, Jeremy Fitzhardinge wrote:

> That seems to have helped.  If I watch
> /proc/acpi/thermal_zone/THM?/temperature, it seems stable even under
> load.   I didn't try watching the thermal_zones when these options were
> enabled, but I presume the temperature was not controlled for it to hit
> 128 degC.
> 
> What's going on here?  Does reading an i2c sensor from the kernel
> prevent something else from doing it?

The i2c drivers access the same hardware as the ACPI methods, and 
there's no locking.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
