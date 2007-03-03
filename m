Return-Path: <linux-kernel-owner+w=401wt.eu-S1030668AbXCCPvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030668AbXCCPvQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 10:51:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030666AbXCCPvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 10:51:16 -0500
Received: from cavan.codon.org.uk ([217.147.92.49]:37462 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030320AbXCCPvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 10:51:15 -0500
Date: Sat, 3 Mar 2007 15:50:49 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: David Hubbard <david.c.hubbard@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org,
       linux-acpi@vger.kernel.org, Chuck Ebbert <cebbert@redhat.com>,
       Rudolf@atrpms.net
Message-ID: <20070303155048.GA22755@srcf.ucam.org>
References: <20070228213803.GA4877@ucw.cz> <20070301152655.f232db64.khali@linux-fr.org> <20070302114023.GD2163@elf.ucw.cz> <20070302114747.GB1212@srcf.ucam.org> <20070302151055.d2665d66.khali@linux-fr.org> <20070302141840.GA3441@srcf.ucam.org> <20070302220454.a0c66d04.khali@linux-fr.org> <20070302211251.GA10035@srcf.ucam.org> <20070303105316.d51e032d.khali@linux-fr.org> <4dfa50520703030747g3c887f5bxe25caefd1723c635@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4dfa50520703030747g3c887f5bxe25caefd1723c635@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 03, 2007 at 08:47:21AM -0700, David Hubbard wrote:

> For I/O and memory that ACPI accesses and has not reserved, the AML
> interpreter could allocate at run-time.

Not ideal. ACPI's already fiddling with ranges that have been reserved 
by other drivers.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
