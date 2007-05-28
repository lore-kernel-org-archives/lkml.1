Return-Path: <linux-kernel-owner+w=401wt.eu-S1759408AbXE1Aii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408AbXE1Aii (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 20:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbXE1Aia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 20:38:30 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:53293 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718AbXE1Ai3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 20:38:29 -0400
Date: Mon, 28 May 2007 01:38:23 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: david-b@pacbell.net
Message-ID: <20070528003822.GA23759@srcf.ucam.org>
References: <20070527190351.GA21387@srcf.ucam.org> <20070527233911.GA23491@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070527233911.GA23491@srcf.ucam.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: RTC_DRV_CMOS can break userspace interface
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2007 at 12:39:11AM +0100, Matthew Garrett wrote:

> but will disable /proc/acpi/wakeup. It'll also be impossible to load 
> CONFIG_RTC_CMOS because CONFIG_RTC has grabbed the io ports, so it's not 
> possible to use the new interface. This situation doesn't appear to be 
> documented, which is less than ideal...

Actually, it seems to be worse than that - the PNP entry for my cmos 
clock doesn't appear to mention an irq, so the wakealarm entry doesn't 
work. I can happily wake it using the /proc/acpi/alarm interface.

David, would you be happy with hardcoding the rtc-cmos IRQ to 8 on PCs 
if there's inadequate PNP information available?
-- 
Matthew Garrett | mjg59@srcf.ucam.org
